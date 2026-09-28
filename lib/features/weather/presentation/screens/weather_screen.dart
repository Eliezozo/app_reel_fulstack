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
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/city_weather.dart';
import '../providers/weather_providers.dart';
import '../weather_icon.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final name = auth is AuthAuthenticated ? auth.user.name : '';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name.isEmpty ? AppStrings.appName : greetingFor(name)),
            const Text(
              AppStrings.weatherTitle,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: AsyncCachedBody<List<CityWeather>>(
        value: ref.watch(weatherProvider),
        onRetry: () => ref.invalidate(weatherProvider),
        dataBuilder: (result) => _WeatherList(
          result: result,
          onRefresh: () async {
            ref.invalidate(weatherProvider);
            await ref.read(weatherProvider.future);
          },
        ),
      ),
    );
  }
}

class _WeatherList extends StatelessWidget {
  const _WeatherList({required this.result, required this.onRefresh});

  final CachedResult<List<CityWeather>> result;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final cities = result.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result.isFromCache) const OfflineBanner(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: cities.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(AppStrings.weatherIntro, style: TextStyle(color: AppColors.textSecondary, height: 1.4)),
                  );
                }
                final city = cities[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => context.push('/weather/${city.id}'),
                    child: Row(
                      children: [
                        Icon(weatherIcon(city.weatherCode), color: AppColors.primary, size: 32),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(city.city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              Text(city.region, style: const TextStyle(color: AppColors.textSecondary)),
                              Text(city.description, style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text(
                          '${city.temperature.round()}°',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary),
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
