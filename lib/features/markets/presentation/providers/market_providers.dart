import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_providers.dart';
import '../../../../core/result/cached_result.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/market_datasources_impl.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/market_repository.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(
    remote: MarketRemoteDataSourceImpl(ref.watch(dioProvider)),
    local: MarketLocalDataSourceImpl(ref.watch(cacheStoreProvider)),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final marketsProvider = FutureProvider<CachedResult<List<Market>>>((ref) {
  return ref.watch(marketRepositoryProvider).getMarkets();
});
