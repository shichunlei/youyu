import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignUtil {
  String getRandomString() {
    final randomNumber = Random().nextDouble();
    final randomBytes = utf8.encode(randomNumber.toString());
    final randomString = md5.convert(randomBytes).toString();
    return randomString;
  }

  // md5(md5(timestamp+random_chars)+md5(random_chars+timestamp))
  String getSignString(String randomString, int timestamp) {
    var md5Sha1Bytes1 = utf8.encode(timestamp.toString() + randomString);
    var md5Sha1Data1 = sha1.convert(md5Sha1Bytes1).toString();
    var md5Bytes1 = utf8.encode(md5Sha1Data1);
    var md5Data1 = md5.convert(md5Bytes1).toString();

    var md5Sha1Bytes2 = utf8.encode(randomString + timestamp.toString());
    var md5Sha1Data2 = sha1.convert(md5Sha1Bytes2).toString();
    var md5Bytes2 = utf8.encode(md5Sha1Data2);
    var md5Data2 = md5.convert(md5Bytes2).toString();

    var md5Sha1Bytes3 = utf8.encode(md5Data1 + md5Data2);
    var md5Sha1Data3 = sha1.convert(md5Sha1Bytes3).toString();
    var md5Bytes3 = utf8.encode(md5Sha1Data3);
    var md5Data3 = md5.convert(md5Bytes3).toString();

    return md5Data3;
  }
}
