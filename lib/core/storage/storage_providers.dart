import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_strings.dart';
import 'cache_store.dart';
import 'token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  throw StateError(AppStrings.storageNotReady);
});

final cacheStoreProvider = Provider<CacheStore>((ref) {
  throw StateError(AppStrings.storageNotReady);
});
