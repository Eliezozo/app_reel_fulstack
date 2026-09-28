import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_providers.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_local_datasource_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.watch(tokenStorageProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: ref.watch(authLocalDataSourceProvider),
  );
});

sealed class AuthState {
  const AuthState();
}

class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthController extends Notifier<AuthState> {
  var _active = true;

  @override
  AuthState build() {
    _active = true;
    final bus = ref.read(sessionBusProvider);
    bus.onExpired = () {
      state = const AuthUnauthenticated();
    };
    ref.onDispose(() {
      _active = false;
      bus.onExpired = null;
    });
    Future<void>.microtask(_restore);
    return const AuthUnknown();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _restore() async {
    final cached = await _repository.readCachedSession();
    if (!_active) return;
    if (cached == null) {
      state = const AuthUnauthenticated();
      return;
    }
    try {
      final user = await _repository.currentUser();
      if (!_active) return;
      state = AuthAuthenticated(user);
    } on AppException catch (error) {
      if (!_active) return;
      final stillCached = await _repository.readCachedSession();
      if (!_active) return;
      if (stillCached == null || error.statusCode == 401) {
        state = const AuthUnauthenticated();
        return;
      }
      state = AuthAuthenticated(stillCached.user);
    }
  }

  Future<void> login({required String email, required String password}) async {
    final session = await _repository.login(email: email, password: password);
    state = AuthAuthenticated(session.user);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final session = await _repository.register(name: name, email: email, password: password);
    state = AuthAuthenticated(session.user);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
