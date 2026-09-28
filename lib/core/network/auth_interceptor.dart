import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../log/app_logger.dart';
import '../storage/token_storage.dart';
import 'session_bus.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.tokenStorage,
    required this.sessionBus,
  });

  final Dio dio;
  final Dio refreshDio;
  final TokenStorage tokenStorage;
  final SessionBus sessionBus;
  Future<bool>? _refreshing;

  bool _isPublic(String path) {
    final normalized = Uri.parse(path).path;
    return normalized == AppConfig.loginPath ||
        normalized == AppConfig.registerPath ||
        normalized == AppConfig.refreshPath;
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isPublic(options.path)) {
      final token = await tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    if (status != 401 || alreadyRetried || _isPublic(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    final refreshed = await _refresh();
    if (!refreshed) {
      await tokenStorage.clear();
      sessionBus.onExpired?.call();
      handler.next(err);
      return;
    }

    final token = await tokenStorage.readAccessToken();
    final request = err.requestOptions;
    request.extra['retried'] = true;
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  Future<bool> _refresh() {
    final inFlight = _refreshing;
    if (inFlight != null) return inFlight;
    final future = _doRefresh();
    _refreshing = future;
    return future.whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refresh = await tokenStorage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final response = await refreshDio.post<dynamic>(
        AppConfig.refreshPath,
        data: {'refreshToken': refresh},
      );
      final data = response.data;
      if (data is! Map) return false;
      final access = data['accessToken'];
      final nextRefresh = data['refreshToken'];
      if (access is! String || nextRefresh is! String) return false;
      await tokenStorage.updateTokens(accessToken: access, refreshToken: nextRefresh);
      return true;
    } on DioException catch (error) {
      AppLogger.debug('Refresh refusé: ${error.message}');
      return false;
    }
  }
}
