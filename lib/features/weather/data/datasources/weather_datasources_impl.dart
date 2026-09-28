import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/log/app_logger.dart';
import '../../../../core/network/json_reader.dart';
import '../../../../core/storage/cache_store.dart';
import '../models/weather_model.dart';
import 'weather_datasources.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CityWeatherModel>> fetchForecasts() async {
    try {
      final response = await _dio.get<dynamic>(AppConfig.weatherPath);
      return readDataList(response.data).map(CityWeatherModel.fromJson).toList(growable: false);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    } on AppException {
      rethrow;
    } catch (error) {
      AppLogger.debug('Météo illisible: $error');
      throw const AppException(AppStrings.invalidPayload);
    }
  }
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  WeatherLocalDataSourceImpl(this._cache);

  final CacheStore _cache;

  @override
  Future<void> cacheForecasts(List<CityWeatherModel> forecasts) {
    return _cache.write(
      CacheKeys.weather,
      jsonEncode(forecasts.map((city) => city.toJson()).toList()),
    );
  }

  @override
  Future<List<CityWeatherModel>?> readForecasts() async {
    final raw = _cache.read(CacheKeys.weather);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.map((item) {
        if (item is! Map) throw const FormatException('item');
        return CityWeatherModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(growable: false);
    } catch (error) {
      AppLogger.debug('Cache météo illisible: $error');
      return null;
    }
  }
}
