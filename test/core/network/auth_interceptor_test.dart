import 'dart:typed_data';

import 'package:app_connectee_backend_reel/core/network/auth_interceptor.dart';
import 'package:app_connectee_backend_reel/core/network/session_bus.dart';
import 'package:app_connectee_backend_reel/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('un 401 déclenche le refresh puis rejoue la requête', () async {
    final storage = _MemoryTokenStorage()
      ..access = 'expired'
      ..refresh = 'refresh-old';
    final bus = SessionBus();
    var expired = false;
    bus.onExpired = () => expired = true;

    final refreshDio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    refreshDio.httpClientAdapter = _ScriptedAdapter(const [200], bodyFor: (status) {
      return '{"accessToken":"access-new","refreshToken":"refresh-new"}';
    });

    final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    dio.httpClientAdapter = _ScriptedAdapter(const [401, 200]);
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        refreshDio: refreshDio,
        tokenStorage: storage,
        sessionBus: bus,
      ),
    );

    final response = await dio.get<Map<String, dynamic>>('/api/markets');

    expect(response.statusCode, 200);
    expect(storage.access, 'access-new');
    expect(storage.refresh, 'refresh-new');
    expect(expired, isFalse);
  });
}

class _MemoryTokenStorage implements TokenStorage {
  String? access;
  String? refresh;
  String? user;

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
    user = null;
  }

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<String?> readUserJson() async => user;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userJson,
  }) async {
    access = accessToken;
    refresh = refreshToken;
    user = userJson;
  }

  @override
  Future<void> updateTokens({required String accessToken, required String refreshToken}) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> updateUserJson(String userJson) async {
    user = userJson;
  }
}

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._statuses, {this.bodyFor});

  final List<int> _statuses;
  final String Function(int status)? bodyFor;
  var _index = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final status = _statuses[_index];
    if (_index < _statuses.length - 1) _index += 1;
    final body = bodyFor?.call(status) ?? (status == 200 ? '{"ok":true}' : '{"message":"expired"}');
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
