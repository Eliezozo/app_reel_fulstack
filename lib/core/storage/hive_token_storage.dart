import 'package:hive/hive.dart';

import 'token_storage.dart';

class HiveBoxes {
  const HiveBoxes._();

  static const String auth = 'auth';
  static const String cache = 'cache';
}

class TokenKeys {
  const TokenKeys._();

  static const String access = 'accessToken';
  static const String refresh = 'refreshToken';
  static const String user = 'userJson';
}

class HiveTokenStorage implements TokenStorage {
  HiveTokenStorage(this._box);

  final Box<String> _box;

  @override
  Future<void> clear() async {
    await _box.delete(TokenKeys.access);
    await _box.delete(TokenKeys.refresh);
    await _box.delete(TokenKeys.user);
  }

  @override
  Future<String?> readAccessToken() async => _box.get(TokenKeys.access);

  @override
  Future<String?> readRefreshToken() async => _box.get(TokenKeys.refresh);

  @override
  Future<String?> readUserJson() async => _box.get(TokenKeys.user);

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userJson,
  }) async {
    await _box.put(TokenKeys.access, accessToken);
    await _box.put(TokenKeys.refresh, refreshToken);
    await _box.put(TokenKeys.user, userJson);
  }

  @override
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _box.put(TokenKeys.access, accessToken);
    await _box.put(TokenKeys.refresh, refreshToken);
  }

  @override
  Future<void> updateUserJson(String userJson) async {
    await _box.put(TokenKeys.user, userJson);
  }
}
