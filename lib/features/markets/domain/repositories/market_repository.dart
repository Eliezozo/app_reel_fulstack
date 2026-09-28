import '../../../../core/result/cached_result.dart';
import '../entities/market.dart';

abstract class MarketRepository {
  Future<CachedResult<List<Market>>> getMarkets();
}
