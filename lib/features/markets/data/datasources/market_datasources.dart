import '../models/market_model.dart';

abstract class MarketRemoteDataSource {
  Future<List<MarketModel>> fetchMarkets();
}

abstract class MarketLocalDataSource {
  Future<List<MarketModel>?> readMarkets();

  Future<void> cacheMarkets(List<MarketModel> markets);
}
