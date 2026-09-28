import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/list_skeleton.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../domain/entities/market.dart';
import '../providers/market_providers.dart';

class MarketDetailScreen extends ConsumerWidget {
  const MarketDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(marketsProvider);
    return list.when(
      loading: () => const Scaffold(body: ListSkeleton()),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.marketsTitle)),
        body: ErrorState(
          message: error is AppException ? error.message : AppStrings.genericError,
          onRetry: () => ref.invalidate(marketsProvider),
        ),
      ),
      data: (result) {
        Market? market;
        for (final item in result.data) {
          if (item.id == id) market = item;
        }
        final selected = market;
        if (selected == null) {
          return const Scaffold(body: Center(child: Text(AppStrings.notFound)));
        }
        final positive = selected.changePercent >= 0;
        return Scaffold(
          appBar: AppBar(title: Text(selected.crop)),
          body: Column(
            children: [
              if (result.isFromCache) const OfflineBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 1,
                  itemBuilder: (context, index) => AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selected.market, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text(
                          formatXof(selected.price),
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                        ),
                        Text('par ${selected.unit}', style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        Text(AppStrings.variation, style: const TextStyle(color: AppColors.textSecondary)),
                        Text(
                          formatChange(selected.changePercent),
                          style: TextStyle(
                            color: positive ? AppColors.primary : AppColors.danger,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${AppStrings.updated} ${formatPublished(selected.updatedAt)}',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
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
