import 'package:app_connectee_backend_reel/core/config/app_strings.dart';
import 'package:app_connectee_backend_reel/core/error/app_exception.dart';
import 'package:app_connectee_backend_reel/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app_connectee_backend_reel/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app_connectee_backend_reel/features/auth/data/models/auth_response_model.dart';
import 'package:app_connectee_backend_reel/features/auth/data/models/user_model.dart';
import 'package:app_connectee_backend_reel/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app_connectee_backend_reel/features/auth/domain/entities/auth_session.dart';
import 'package:app_connectee_backend_reel/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const user = UserModel(id: '1', name: 'Ama Koffi', email: 'demo@agriboard.tg');
  const response = AuthResponseModel(
    user: user,
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  test('login enregistre la session et renvoie l’utilisateur', () async {
    final local = _FakeAuthLocal();
    final repository = AuthRepositoryImpl(
      remote: _FakeAuthRemote(session: response),
      local: local,
    );

    final session = await repository.login(email: user.email, password: 'demo1234');

    expect(session.user.name, 'Ama Koffi');
    expect(session.accessToken, 'access');
    expect(local.saveCount, 1);
    expect(local.saved?.refreshToken, 'refresh');
  });

  test('login en échec ne sauvegarde pas de session', () async {
    final local = _FakeAuthLocal();
    final repository = AuthRepositoryImpl(
      remote: _FakeAuthRemote(error: const AppException('Email ou mot de passe incorrect.', statusCode: 401)),
      local: local,
    );

    expect(
      () => repository.login(email: 'demo@agriboard.tg', password: 'mauvais'),
      throwsA(
        isA<AppException>().having((error) => error.message, 'message', 'Email ou mot de passe incorrect.'),
      ),
    );
    expect(local.saveCount, 0);
  });

  test('logout efface la session locale même si le serveur est injoignable', () async {
    final local = _FakeAuthLocal()
      ..saved = AuthSession(user: user.toEntity(), accessToken: 'access', refreshToken: 'refresh');
    final repository = AuthRepositoryImpl(
      remote: _FakeAuthRemote(error: const AppException(AppStrings.networkError)),
      local: local,
    );

    await repository.logout();

    expect(local.cleared, isTrue);
    expect(local.saved, isNull);
  });
}

class _FakeAuthRemote implements AuthRemoteDataSource {
  _FakeAuthRemote({this.session, this.error});

  final AuthResponseModel? session;
  final AppException? error;

  Future<T> _guard<T>(T? value) async {
    final failure = error;
    if (failure != null) throw failure;
    if (value == null) throw const AppException(AppStrings.genericError);
    return value;
  }

  @override
  Future<AuthResponseModel> login({required String email, required String password}) {
    return _guard(session);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    final failure = error;
    if (failure != null) throw failure;
  }

  @override
  Future<UserModel> me() => _guard(session?.user);

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(session);
  }
}

class _FakeAuthLocal implements AuthLocalDataSource {
  AuthSession? saved;
  var saveCount = 0;
  var cleared = false;

  @override
  Future<void> clear() async {
    saved = null;
    cleared = true;
  }

  @override
  Future<AuthSession?> readSession() async => saved;

  @override
  Future<void> saveSession(AuthSession session) async {
    saved = session;
    saveCount += 1;
  }

  @override
  Future<void> updateUser(User user) async {
    final current = saved;
    if (current == null) return;
    saved = AuthSession(user: user, accessToken: current.accessToken, refreshToken: current.refreshToken);
  }
}
