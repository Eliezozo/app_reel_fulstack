import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/log/app_logger.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return _postSession(AppConfig.loginPath, {
      'email': email,
      'password': password,
    });
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      await _dio.post<void>(AppConfig.logoutPath, data: {'refreshToken': refreshToken});
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  @override
  Future<UserModel> me() async {
    try {
      final response = await _dio.get<dynamic>(AppConfig.mePath);
      final body = response.data;
      if (body is! Map) {
        throw const AppException(AppStrings.invalidPayload);
      }
      final user = body['user'];
      if (user is! Map) {
        throw const AppException(AppStrings.invalidPayload);
      }
      return UserModel.fromJson(Map<String, dynamic>.from(user));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    } on AppException {
      rethrow;
    } catch (error) {
      AppLogger.debug('Profil illisible: $error');
      throw const AppException(AppStrings.invalidPayload);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _postSession(AppConfig.registerPath, {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<AuthResponseModel> _postSession(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      final body = response.data;
      if (body is! Map) {
        throw const AppException(AppStrings.invalidPayload);
      }
      return AuthResponseModel.fromJson(Map<String, dynamic>.from(body));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    } on AppException {
      rethrow;
    } catch (error) {
      AppLogger.debug('Session illisible: $error');
      throw const AppException(AppStrings.invalidPayload);
    }
  }
}
