import 'package:dio/dio.dart';

import '../config/app_strings.dart';

class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory AppException.fromDio(DioException error) {
    final serverMessage = _serverMessage(error);
    if (serverMessage != null) {
      return AppException(serverMessage, statusCode: error.response?.statusCode);
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        const AppException(AppStrings.networkError),
      _ => AppException(
          error.response?.statusCode == 401
              ? AppStrings.sessionExpired
              : AppStrings.genericError,
          statusCode: error.response?.statusCode,
        ),
    };
  }

  static String? _serverMessage(DioException error) {
    final data = error.response?.data;
    if (data is! Map) return null;
    final message = data['message'];
    if (message is! String) return null;
    final trimmed = message.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  String toString() => message;
}
