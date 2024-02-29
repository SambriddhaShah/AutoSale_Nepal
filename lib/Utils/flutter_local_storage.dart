import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureData {
  static const _storage = FlutterSecureStorage();

  // static const String contentId = "1";
  static const String useName = "userName";
  static const String password = "password";
  static const String checked = "isChecked";

  // static Future<void> saveAppleLogin(
  //     AppleLoginReponseDTO data, String userIdentifier) {
  //   return _storage.write(
  //       key: userIdentifier, value: jsonEncode(data.toJson()));
  // }

  // static Future<AppleLoginReponseDTO?> readAppleLogin(
  //     String userIdentifier) async {
  //   final response = await _storage.read(key: userIdentifier);
  //   if (response?.isNotEmpty ?? false) {
  //     return AppleLoginReponseDTO.fromJson(jsonDecode(response!));
  //   }
  //   return null;
  // }

  // static Future<void> deleteAppleLogin(String userIdentifier) {
  //   return _storage.delete(key: userIdentifier);
  // }

  // flutter secure storage for the user uid
  static Future<void> setUserUid(String usename) {
    return _storage.write(key: 'Uid', value: usename);
  }

  static Future<String?> getUserUid() {
    return _storage.read(key: 'Uid');
  }

  static Future<void> deleteUserUid() {
    return _storage.delete(key: 'Uid');
  }

  static Future<void> setUserName(String usename) {
    return _storage.write(key: useName, value: usename);
  }

  static Future<String?> getUserName() {
    return _storage.read(key: useName);
  }

  static Future<void> deleteUserName() {
    return _storage.delete(key: useName);
  }

  static Future<void> setPassword(String passWord) {
    return _storage.write(key: password, value: passWord);
  }

  static Future<String?> getPassword() {
    return _storage.read(key: password);
  }

  static Future<void> deletePassword() {
    return _storage.delete(key: password);
  }

  static Future<void> setRememberMe(bool isChecked) {
    return _storage.write(key: checked, value: isChecked.toString());
  }

  static Future<String?> getRememberMe() {
    return _storage.read(key: checked);
  }
}
