import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<List<CityWeatherModel>> fetchForecasts();
}

abstract class WeatherLocalDataSource {
  Future<List<CityWeatherModel>?> readForecasts();

  Future<void> cacheForecasts(List<CityWeatherModel> forecasts);
}
