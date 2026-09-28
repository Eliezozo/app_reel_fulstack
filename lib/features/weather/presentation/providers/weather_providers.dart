import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_providers.dart';
import '../../../../core/result/cached_result.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/weather_datasources_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/city_weather.dart';
import '../../domain/repositories/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remote: WeatherRemoteDataSourceImpl(ref.watch(dioProvider)),
    local: WeatherLocalDataSourceImpl(ref.watch(cacheStoreProvider)),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final weatherProvider = FutureProvider<CachedResult<List<CityWeather>>>((ref) {
  return ref.watch(weatherRepositoryProvider).getForecasts();
});
