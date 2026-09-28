import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/news_article.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsArticleModel with _$NewsArticleModel {
  const factory NewsArticleModel({
    required String id,
    required String title,
    required String summary,
    required String body,
    required String category,
    required String source,
    required String publishedAt,
  }) = _NewsArticleModel;

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleModelFromJson(json);
}

extension NewsArticleMapper on NewsArticleModel {
  NewsArticle toEntity() => NewsArticle(
        id: id,
        title: title,
        summary: summary,
        body: body,
        category: category,
        source: source,
        publishedAt: publishedAt,
      );
}
