import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/list_skeleton.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../domain/entities/news_article.dart';
import '../providers/news_providers.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(newsProvider);
    return list.when(
      loading: () => const Scaffold(body: ListSkeleton()),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.newsTitle)),
        body: ErrorState(
          message: error is AppException ? error.message : AppStrings.genericError,
          onRetry: () => ref.invalidate(newsProvider),
        ),
      ),
      data: (result) {
        NewsArticle? article;
        for (final item in result.data) {
          if (item.id == id) article = item;
        }
        final selected = article;
        if (selected == null) {
          return const Scaffold(body: Center(child: Text(AppStrings.notFound)));
        }
        return Scaffold(
          appBar: AppBar(title: Text(selected.category)),
          body: Column(
            children: [
              if (result.isFromCache) const OfflineBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 1,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.title,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${selected.source} · ${formatPublished(selected.publishedAt)}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),
                      Text(selected.body, style: const TextStyle(height: 1.5, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
