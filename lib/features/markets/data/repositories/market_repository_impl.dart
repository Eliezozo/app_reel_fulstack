import '../../../../core/network/fetch_with_cache.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/cached_result.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/market_datasources.dart';
import '../models/market_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  final MarketRemoteDataSource remote;
  final MarketLocalDataSource local;
  final NetworkInfo networkInfo;

  @override
  Future<CachedResult<List<Market>>> getMarkets() {
    return fetchWithCache(
      networkInfo: networkInfo,
      fetch: remote.fetchMarkets,
      readCache: local.readMarkets,
      writeCache: local.cacheMarkets,
      map: (MarketModel model) => model.toEntity(),
    );
  }
}
