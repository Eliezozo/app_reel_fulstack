import 'dart:convert';

import '../../../../core/log/app_logger.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final TokenStorage _storage;

  @override
  Future<void> clear() => _storage.clear();

  @override
  Future<AuthSession?> readSession() async {
    final access = await _storage.readAccessToken();
    final refresh = await _storage.readRefreshToken();
    final rawUser = await _storage.readUserJson();
    if (access == null ||
        access.isEmpty ||
        refresh == null ||
        refresh.isEmpty ||
        rawUser == null ||
        rawUser.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(rawUser);
      if (decoded is! Map) return null;
      final user = UserModel.fromJson(Map<String, dynamic>.from(decoded)).toEntity();
      return AuthSession(user: user, accessToken: access, refreshToken: refresh);
    } catch (error) {
      AppLogger.debug('Session locale illisible: $error');
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSession session) {
    return _storage.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userJson: jsonEncode(session.user.toModel().toJson()),
    );
  }

  @override
  Future<void> updateUser(User user) {
    return _storage.updateUserJson(jsonEncode(user.toModel().toJson()));
  }
}
