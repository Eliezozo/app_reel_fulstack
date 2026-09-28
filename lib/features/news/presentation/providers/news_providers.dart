import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_providers.dart';
import '../../../../core/result/cached_result.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/news_datasources_impl.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    remote: NewsRemoteDataSourceImpl(ref.watch(dioProvider)),
    local: NewsLocalDataSourceImpl(ref.watch(cacheStoreProvider)),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final newsProvider = FutureProvider<CachedResult<List<NewsArticle>>>((ref) {
  return ref.watch(newsRepositoryProvider).getArticles();
});
