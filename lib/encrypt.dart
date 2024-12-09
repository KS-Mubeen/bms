import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/services.dart'; // To load keys from assets

class encryption {
  RSAPublicKey? publicKey;
  RSAPrivateKey? privateKey;

  encryption();

  // Load RSA keys from assets (async method)
  Future<void> loadKeys() async {
    try {
      // Load public and private keys as strings from assets
      final publicKeyString = await rootBundle.loadString('assets/public.pem');
      final privateKeyString = await rootBundle.loadString('assets/private.pem');

      // String username = "Mubeen";
      // final publicKeyPem = '''
      // -----BEGIN PUBLIC KEY-----
      // {$username}
      // -----END PUBLIC KEY-----
      // ''';
      //
      // String password = "Mubeen123";
      // final privateKeyPem = '''
      // -----BEGIN PUBLIC KEY-----
      // {$password}
      // -----END PUBLIC KEY-----
      // ''';
      // final publicKeyString = await publicKeyPem;
      // final privateKeyString = await privateKeyPem;

      // Parse the RSA keys from the PEM strings
      final parser = RSAKeyParser();
      publicKey = parser.parse(publicKeyString) as RSAPublicKey;
      privateKey = parser.parse(privateKeyString) as RSAPrivateKey;
    } catch (e) {
      throw Exception('Error loading keys: $e');
    }
  }

  // Function to encrypt the plain text with the public key
  String encrypt(String plainText) {
    if (publicKey == null) {
      throw Exception("Public key is not loaded");
    }

    // Create an Encrypter instance with the public key
    final encrypter = Encrypter(RSA(publicKey: publicKey!));

    // Encrypt the plain text
    final encrypted = encrypter.encrypt(plainText);

    // Return the encrypted data in Base64 format
    print('Encrypted Text (Base64): ${encrypted}');
    return encrypted.base64;
  }

  // Function to decrypt the encrypted text with the private key
  String decrypt(String encryptedBase64) {
    if (privateKey == null) {
      throw Exception("Private key is not loaded");
    }

    // Create an Encrypter instance with the private key
    final encrypter = Encrypter(RSA(privateKey: privateKey!));

    // Convert the Base64 encrypted text back to an Encrypted object
    final encrypted = Encrypted.fromBase64(encryptedBase64);

    // Decrypt the encrypted text using the private key
    final decrypted = encrypter.decrypt(encrypted);

    // Return the decrypted text
    return decrypted;
  }
}
