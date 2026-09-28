import '../../../../core/result/cached_result.dart';
import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<CachedResult<List<NewsArticle>>> getArticles();
}
