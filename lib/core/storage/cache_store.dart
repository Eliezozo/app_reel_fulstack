abstract class CacheStore {
  String? read(String key);

  Future<void> write(String key, String value);
}

class CacheKeys {
  const CacheKeys._();

  static const String markets = 'markets';
  static const String weather = 'weather';
  static const String news = 'news';
}
