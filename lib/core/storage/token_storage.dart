abstract class TokenStorage {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<String?> readUserJson();

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userJson,
  });

  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> updateUserJson(String userJson);

  Future<void> clear();
}
