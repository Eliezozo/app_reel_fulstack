import '../../../../core/error/app_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.local});

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<User> currentUser() async {
    final user = (await remote.me()).toEntity();
    await local.updateUser(user);
    return user;
  }

  @override
  Future<AuthSession> login({required String email, required String password}) async {
    final session = (await remote.login(email: email, password: password)).toSession();
    await local.saveSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    final session = await local.readSession();
    if (session != null) {
      try {
        await remote.logout(refreshToken: session.refreshToken);
      } on AppException {
        // La session locale est effacée même si le serveur ne répond pas.
      }
    }
    await local.clear();
  }

  @override
  Future<AuthSession?> readCachedSession() => local.readSession();

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final session = (await remote.register(name: name, email: email, password: password)).toSession();
    await local.saveSession(session);
    return session;
  }
}
