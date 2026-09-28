import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String email, required String password});

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> me();

  Future<void> logout({required String refreshToken});
}
