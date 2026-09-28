import 'package:app_connectee_backend_reel/core/config/app_strings.dart';
import 'package:app_connectee_backend_reel/core/error/app_exception.dart';
import 'package:app_connectee_backend_reel/core/network/network_info.dart';
import 'package:app_connectee_backend_reel/features/markets/data/datasources/market_datasources.dart';
import 'package:app_connectee_backend_reel/features/markets/data/models/market_model.dart';
import 'package:app_connectee_backend_reel/features/markets/data/repositories/market_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const market = MarketModel(
    id: 'mais-lome',
    crop: 'Maïs',
    market: 'Lomé',
    unit: 'kg',
    price: 275,
    currency: 'XOF',
    changePercent: 1.8,
    updatedAt: '2026-09-28T08:00:00.000Z',
  );

  test('en ligne, les marchés sont lus puis mis en cache', () async {
    final remote = _FakeMarketRemote(markets: const [market]);
    final local = _FakeMarketLocal();
    final repository = MarketRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: _FakeNetwork(true),
    );

    final result = await repository.getMarkets();

    expect(result.isFromCache, isFalse);
    expect(result.data.single.crop, 'Maïs');
    expect(result.data.single.price, 275);
    expect(local.writes, 1);
    expect(remote.calls, 1);
  });

  test('hors ligne, le cache est renvoyé sans appel réseau', () async {
    final remote = _FakeMarketRemote(error: const AppException(AppStrings.networkError));
    final local = _FakeMarketLocal()..stored = const [market];
    final repository = MarketRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: _FakeNetwork(false),
    );

    final result = await repository.getMarkets();

    expect(result.isFromCache, isTrue);
    expect(result.data.single.market, 'Lomé');
    expect(remote.calls, 0);
  });

  test('hors ligne et sans cache, un message clair est renvoyé', () async {
    final repository = MarketRepositoryImpl(
      remote: _FakeMarketRemote(),
      local: _FakeMarketLocal(),
      networkInfo: _FakeNetwork(false),
    );

    expect(
      repository.getMarkets,
      throwsA(
        isA<AppException>().having((error) => error.message, 'message', AppStrings.offlineEmpty),
      ),
    );
  });
}

class _FakeNetwork implements NetworkInfo {
  _FakeNetwork(this.online);

  final bool online;

  @override
  Future<bool> get isConnected async => online;
}

class _FakeMarketRemote implements MarketRemoteDataSource {
  _FakeMarketRemote({this.markets = const [], this.error});

  final List<MarketModel> markets;
  final AppException? error;
  var calls = 0;

  @override
  Future<List<MarketModel>> fetchMarkets() async {
    calls += 1;
    final failure = error;
    if (failure != null) throw failure;
    return markets;
  }
}

class _FakeMarketLocal implements MarketLocalDataSource {
  List<MarketModel>? stored;
  var writes = 0;

  @override
  Future<void> cacheMarkets(List<MarketModel> markets) async {
    stored = markets;
    writes += 1;
  }

  @override
  Future<List<MarketModel>?> readMarkets() async => stored;
}
