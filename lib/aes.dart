import 'dart:typed_data'; // For Uint8List
import 'dart:math'; // For generating random bytes
import 'package:encrypt/encrypt.dart';
import 'secure_storage.dart';

class AESEncryption {
  late String _aesKeyHex;
  late List<int> _aesKeyBytes;
  late IV _aesIV; // Store the generated IV

  AESEncryption() {
    _initializeKeys();
    _generateRandomIV();
  }

  Future<void> _initializeKeys() async {
    String username = await SecureStorage().readSecureData("username");
    _aesKeyHex = await SecureStorage().readSecureData(username);
    _aesKeyBytes = _decodeHex(_aesKeyHex);
    //print("Decoded AES Key: $_aesKeyBytes");
  }

  void _generateRandomIV() {
    final random = Random.secure();
    _aesIV = IV(Uint8List.fromList(
        List<int>.generate(16, (_) => random.nextInt(256))));
    print("Generated IV: ${_aesIV.base16}");
  }

  Key _getKey() => Key(Uint8List.fromList(_aesKeyBytes));

  List<int> _decodeHex(String hex) {
    return List<int>.generate(hex.length ~/ 2,
            (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16));
  }

  String encrypt(String plainText) {
    if (_aesKeyBytes.isEmpty) {
      throw Exception("AES key is not initialized.");
    }

    final encrypter = Encrypter(AES(_getKey()));
    final encrypted = encrypter.encrypt(plainText, iv: _aesIV);
    return "${_aesIV.base64}:${encrypted.base64}";
  }

  String decrypt(String encryptedData) {
    if (_aesKeyBytes.isEmpty) {
      throw Exception("AES key is not initialized.");
    }

    final parts = encryptedData.split(':');
    if (parts.length != 2) {
      throw Exception("Invalid encrypted data format.");
    }

    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);

    final encrypter = Encrypter(AES(_getKey()));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
