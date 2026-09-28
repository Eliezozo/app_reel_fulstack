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
import '../../domain/entities/city_weather.dart';
import '../providers/weather_providers.dart';
import '../weather_icon.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(weatherProvider);
    return list.when(
      loading: () => const Scaffold(body: ListSkeleton()),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.weatherTitle)),
        body: ErrorState(
          message: error is AppException ? error.message : AppStrings.genericError,
          onRetry: () => ref.invalidate(weatherProvider),
        ),
      ),
      data: (result) {
        CityWeather? city;
        for (final item in result.data) {
          if (item.id == id) city = item;
        }
        final selected = city;
        if (selected == null) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.notFound)),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(selected.city)),
          body: Column(
            children: [
              if (result.isFromCache) const OfflineBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: selected.daily.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _Header(city: selected);
                    final day = selected.daily[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        child: Row(
                          children: [
                            Icon(weatherIcon(day.weatherCode), color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(child: Text(formatWeekday(day.date))),
                            Text('${day.tempMin.round()}° / ${day.tempMax.round()}°'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.city});

  final CityWeather city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${city.temperature.round()}°',
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800, height: 1),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(city.description, style: const TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
          if (city.estimated)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(AppStrings.estimated, style: TextStyle(color: AppColors.warning)),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Metric(label: AppStrings.humidity, value: '${city.humidity} %'),
              _Metric(label: AppStrings.wind, value: '${city.windSpeed.round()} km/h'),
              _Metric(
                label: AppStrings.rain,
                value: '${city.precipitation.toStringAsFixed(1).replaceAll('.', ',')} mm',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(AppStrings.nextDays, style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
