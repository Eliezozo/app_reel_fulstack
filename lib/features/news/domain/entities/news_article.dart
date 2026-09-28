class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.source,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final String category;
  final String source;
  final String publishedAt;
}
