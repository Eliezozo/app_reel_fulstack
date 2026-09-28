import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_strings.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/log/app_logger.dart';
import '../../../../core/network/json_reader.dart';
import '../../../../core/storage/cache_store.dart';
import '../models/market_model.dart';
import 'market_datasources.dart';

class MarketRemoteDataSourceImpl implements MarketRemoteDataSource {
  MarketRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<MarketModel>> fetchMarkets() async {
    try {
      final response = await _dio.get<dynamic>(AppConfig.marketsPath);
      return readDataList(response.data).map(MarketModel.fromJson).toList(growable: false);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    } on AppException {
      rethrow;
    } catch (error) {
      AppLogger.debug('Marchés illisibles: $error');
      throw const AppException(AppStrings.invalidPayload);
    }
  }
}

class MarketLocalDataSourceImpl implements MarketLocalDataSource {
  MarketLocalDataSourceImpl(this._cache);

  final CacheStore _cache;

  @override
  Future<void> cacheMarkets(List<MarketModel> markets) {
    return _cache.write(
      CacheKeys.markets,
      jsonEncode(markets.map((market) => market.toJson()).toList()),
    );
  }

  @override
  Future<List<MarketModel>?> readMarkets() async {
    final raw = _cache.read(CacheKeys.markets);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.map((item) {
        if (item is! Map) {
          throw const FormatException('item');
        }
        return MarketModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(growable: false);
    } catch (error) {
      AppLogger.debug('Cache marchés illisible: $error');
      return null;
    }
  }
}
