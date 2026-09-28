// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsArticleModel _$NewsArticleModelFromJson(Map<String, dynamic> json) =>
    _NewsArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      source: json['source'] as String,
      publishedAt: json['publishedAt'] as String,
    );

Map<String, dynamic> _$NewsArticleModelToJson(_NewsArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'body': instance.body,
      'category': instance.category,
      'source': instance.source,
      'publishedAt': instance.publishedAt,
    };
