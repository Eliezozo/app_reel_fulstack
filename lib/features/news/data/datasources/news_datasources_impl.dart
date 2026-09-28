import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/log/app_logger.dart';
import '../../../../core/network/json_reader.dart';
import '../../../../core/storage/cache_store.dart';
import '../models/news_model.dart';
import 'news_datasources.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  NewsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<NewsArticleModel>> fetchArticles() async {
    try {
      final response = await _dio.get<dynamic>(AppConfig.newsPath);
      return readDataList(response.data).map(NewsArticleModel.fromJson).toList(growable: false);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    } on AppException {
      rethrow;
    } catch (error) {
      AppLogger.debug('Bulletins illisibles: $error');
      throw const AppException(AppStrings.invalidPayload);
    }
  }
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  NewsLocalDataSourceImpl(this._cache);

  final CacheStore _cache;

  @override
  Future<void> cacheArticles(List<NewsArticleModel> articles) {
    return _cache.write(
      CacheKeys.news,
      jsonEncode(articles.map((article) => article.toJson()).toList()),
    );
  }

  @override
  Future<List<NewsArticleModel>?> readArticles() async {
    final raw = _cache.read(CacheKeys.news);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.map((item) {
        if (item is! Map) throw const FormatException('item');
        return NewsArticleModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(growable: false);
    } catch (error) {
      AppLogger.debug('Cache bulletins illisible: $error');
      return null;
    }
  }
}
