import '../config/app_strings.dart';
import '../error/app_exception.dart';
import '../log/app_logger.dart';
import '../result/cached_result.dart';
import 'network_info.dart';

Future<CachedResult<List<T>>> fetchWithCache<M, T>({
  required NetworkInfo networkInfo,
  required Future<List<M>> Function() fetch,
  required Future<List<M>?> Function() readCache,
  required Future<void> Function(List<M> value) writeCache,
  required T Function(M model) map,
}) async {
  Future<CachedResult<List<T>>?> readMapped() async {
    final cached = await readCache();
    if (cached == null || cached.isEmpty) return null;
    return CachedResult(
      data: cached.map(map).toList(growable: false),
      isFromCache: true,
    );
  }

  final online = await networkInfo.isConnected;
  if (!online) {
    final cached = await readMapped();
    if (cached != null) return cached;
    throw const AppException(AppStrings.offlineEmpty);
  }

  try {
    final models = await fetch();
    try {
      await writeCache(models);
    } catch (error) {
      AppLogger.debug('Écriture du cache impossible: $error');
    }
    return CachedResult(
      data: models.map(map).toList(growable: false),
      isFromCache: false,
    );
    } on AppException {
      final cached = await readMapped();
      if (cached != null) return cached;
      rethrow;
    }
}
