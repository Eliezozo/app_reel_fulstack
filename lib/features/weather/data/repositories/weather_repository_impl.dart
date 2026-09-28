import '../../../../core/network/fetch_with_cache.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/cached_result.dart';
import '../../domain/entities/city_weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_datasources.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  final WeatherRemoteDataSource remote;
  final WeatherLocalDataSource local;
  final NetworkInfo networkInfo;

  @override
  Future<CachedResult<List<CityWeather>>> getForecasts() {
    return fetchWithCache(
      networkInfo: networkInfo,
      fetch: remote.fetchForecasts,
      readCache: local.readForecasts,
      writeCache: local.cacheForecasts,
      map: (CityWeatherModel model) => model.toEntity(),
    );
  }
}
