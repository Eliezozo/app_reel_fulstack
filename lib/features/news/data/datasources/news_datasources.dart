import '../models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsArticleModel>> fetchArticles();
}

abstract class NewsLocalDataSource {
  Future<List<NewsArticleModel>?> readArticles();

  Future<void> cacheArticles(List<NewsArticleModel> articles);
}
