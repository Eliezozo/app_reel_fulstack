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
import '../../domain/entities/market.dart';
import '../providers/market_providers.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.marketsTitle)),
      body: AsyncCachedBody<List<Market>>(
        value: ref.watch(marketsProvider),
        onRetry: () => ref.invalidate(marketsProvider),
        dataBuilder: (result) => _MarketList(
          result: result,
          onRefresh: () async {
            ref.invalidate(marketsProvider);
            await ref.read(marketsProvider.future);
          },
        ),
      ),
    );
  }
}

class _MarketList extends StatelessWidget {
  const _MarketList({required this.result, required this.onRefresh});

  final CachedResult<List<Market>> result;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final markets = result.data;
    return Column(
      children: [
        if (result.isFromCache) const OfflineBanner(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: markets.isEmpty ? 2 : markets.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(AppStrings.marketsIntro, style: TextStyle(color: AppColors.textSecondary, height: 1.4)),
                  );
                }
                if (markets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: Text(AppStrings.emptyList)),
                  );
                }
                final market = markets[index - 1];
                final positive = market.changePercent >= 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => context.push('/markets/${market.id}'),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(market.crop, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              Text(market.market, style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formatXof(market.price), style: const TextStyle(fontWeight: FontWeight.w800)),
                            Text(
                              formatChange(market.changePercent),
                              style: TextStyle(color: positive ? AppColors.primary : AppColors.danger),
                            ),
                          ],
                        ),
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
