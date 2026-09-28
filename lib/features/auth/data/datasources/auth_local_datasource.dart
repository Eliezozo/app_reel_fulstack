import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(AuthSession session);

  Future<AuthSession?> readSession();

  Future<void> updateUser(User user);

  Future<void> clear();
}
