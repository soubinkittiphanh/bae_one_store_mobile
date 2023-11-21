import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _keyLogId = "log_id";
  static const _keyLogPass = "log_pass";
  static const _keyLogRemember = "log_remember";
  static const _storage = FlutterSecureStorage();
  static Future setLoginId(String userId) async {
    await _storage.write(key: _keyLogId, value: userId);
  }

  static Future<String?> getLoginId() async =>
      await _storage.read(key: _keyLogId);

  static Future setLoginPassword(String password) async {
    await _storage.write(key: _keyLogPass, value: password);
  }

  static Future<String?> getLoginPass() async =>
      await _storage.read(key: _keyLogPass);

  static Future setRemember(String isRemember) async {
    await _storage.write(key: _keyLogRemember, value: isRemember);
  }

  static Future<String?> getRemember() async =>
      await _storage.read(key: _keyLogRemember);
}
