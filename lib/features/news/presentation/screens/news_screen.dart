import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_strings.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/result/cached_result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/async_cached_body.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../domain/entities/news_article.dart';
import '../providers/news_providers.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.newsTitle)),
      body: AsyncCachedBody<List<NewsArticle>>(
        value: ref.watch(newsProvider),
        onRetry: () => ref.invalidate(newsProvider),
        dataBuilder: (result) => _NewsList(
          result: result,
          onRefresh: () async {
            ref.invalidate(newsProvider);
            await ref.read(newsProvider.future);
          },
        ),
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList({required this.result, required this.onRefresh});

  final CachedResult<List<NewsArticle>> result;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final articles = result.data;
    return Column(
      children: [
        if (result.isFromCache) const OfflineBanner(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(AppStrings.newsIntro, style: TextStyle(color: AppColors.textSecondary, height: 1.4)),
                  );
                }
                final article = articles[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => context.push('/news/${article.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.category, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(article.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.25)),
                        const SizedBox(height: 8),
                        Text(article.summary, style: const TextStyle(color: AppColors.textSecondary, height: 1.35)),
                        const SizedBox(height: 10),
                        Text(formatPublished(article.publishedAt), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
