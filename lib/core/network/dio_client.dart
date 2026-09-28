import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'session_bus.dart';

Dio createDio({
  required TokenStorage tokenStorage,
  required SessionBus sessionBus,
}) {
  final options = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );
  final refreshDio = Dio(options);
  final dio = Dio(options);
  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      refreshDio: refreshDio,
      tokenStorage: tokenStorage,
      sessionBus: sessionBus,
    ),
  );
  return dio;
}
