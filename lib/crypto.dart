import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashingHelper {
  /// Function to compute the SHA-256 hash of a given input text.
  String computeSHA256(String inputText) {
    // Convert input string to bytes
    List<int> bytes = utf8.encode(inputText);

    // Compute the hash
    Digest hash = sha256.convert(bytes);

    // Return the hash as a hexadecimal string
    return hash.toString();
  }
}
