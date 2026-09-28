import '../../../../core/result/cached_result.dart';
import '../entities/city_weather.dart';

abstract class WeatherRepository {
  Future<CachedResult<List<CityWeather>>> getForecasts();
}
