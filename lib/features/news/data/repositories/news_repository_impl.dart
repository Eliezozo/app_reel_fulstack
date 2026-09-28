import '../../../../core/network/fetch_with_cache.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/cached_result.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_datasources.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  final NewsRemoteDataSource remote;
  final NewsLocalDataSource local;
  final NetworkInfo networkInfo;

  @override
  Future<CachedResult<List<NewsArticle>>> getArticles() {
    return fetchWithCache(
      networkInfo: networkInfo,
      fetch: remote.fetchArticles,
      readCache: local.readArticles,
      writeCache: local.cacheArticles,
      map: (NewsArticleModel model) => model.toEntity(),
    );
  }
}
