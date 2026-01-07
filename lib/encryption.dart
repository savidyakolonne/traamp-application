import 'dart:convert'; // for utf8.encode
import 'package:crypto/crypto.dart'; // for sha256
import 'package:convert/convert.dart'; // for hex encoding

class Encryption {
  static String generateSha256(String input) {
    var bytes = utf8.encode(input); // convert string to bytes
    var digest = sha256.convert(bytes); // compute SHA-256 hash
    return hex.encode(digest.bytes); // convert to hex string
  }
}
