import 'package:app_connectee_backend_reel/core/config/app_strings.dart';
import 'package:app_connectee_backend_reel/core/error/app_exception.dart';
import 'package:app_connectee_backend_reel/core/network/network_info.dart';
import 'package:app_connectee_backend_reel/features/news/data/datasources/news_datasources.dart';
import 'package:app_connectee_backend_reel/features/news/data/models/news_model.dart';
import 'package:app_connectee_backend_reel/features/news/data/repositories/news_repository_impl.dart';
import 'package:app_connectee_backend_reel/features/weather/data/datasources/weather_datasources.dart';
import 'package:app_connectee_backend_reel/features/weather/data/models/weather_model.dart';
import 'package:app_connectee_backend_reel/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const article = NewsArticleModel(
    id: 'pluies-semis',
    title: 'Pluies utiles',
    summary: 'Caler les semis',
    body: 'Texte',
    category: 'Météo',
    source: 'Bulletin AgriBoard',
    publishedAt: '2026-09-24T07:40:00.000Z',
  );

  const city = CityWeatherModel(
    id: 'lome',
    city: 'Lomé',
    region: 'Maritime',
    temperature: 28.5,
    humidity: 78,
    windSpeed: 12,
    weatherCode: 2,
    description: 'Nuageux',
    precipitation: 0.2,
    estimated: false,
    daily: [
      DailyForecastModel(
        date: '2026-09-28',
        tempMin: 24,
        tempMax: 31,
        weatherCode: 2,
        precipitation: 1,
      ),
    ],
  );

  test('une erreur réseau des bulletins retombe sur le cache', () async {
    final repository = NewsRepositoryImpl(
      remote: _FakeNewsRemote(error: const AppException(AppStrings.networkError)),
      local: _FakeNewsLocal()..stored = const [article],
      networkInfo: _Online(),
    );

    final result = await repository.getArticles();

    expect(result.isFromCache, isTrue);
    expect(result.data.single.title, 'Pluies utiles');
  });

  test('la météo hors ligne sans cache explique l’absence de données', () async {
    final repository = WeatherRepositoryImpl(
      remote: _FakeWeatherRemote(),
      local: _FakeWeatherLocal(),
      networkInfo: _Offline(),
    );

    expect(
      repository.getForecasts,
      throwsA(isA<AppException>().having((error) => error.message, 'message', AppStrings.offlineEmpty)),
    );
  });

  test('la météo en ligne met les prévisions en cache', () async {
    final local = _FakeWeatherLocal();
    final repository = WeatherRepositoryImpl(
      remote: _FakeWeatherRemote(cities: const [city]),
      local: local,
      networkInfo: _Online(),
    );

    final result = await repository.getForecasts();

    expect(result.isFromCache, isFalse);
    expect(result.data.single.daily.single.tempMax, 31);
    expect(local.writes, 1);
  });
}

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

class _FakeNewsRemote implements NewsRemoteDataSource {
  _FakeNewsRemote({this.error});

  final AppException? error;

  @override
  Future<List<NewsArticleModel>> fetchArticles() async {
    final failure = error;
    if (failure != null) throw failure;
    return const [];
  }
}

class _FakeNewsLocal implements NewsLocalDataSource {
  List<NewsArticleModel>? stored;

  @override
  Future<void> cacheArticles(List<NewsArticleModel> articles) async {
    stored = articles;
  }

  @override
  Future<List<NewsArticleModel>?> readArticles() async => stored;
}

class _FakeWeatherRemote implements WeatherRemoteDataSource {
  _FakeWeatherRemote({this.cities = const []});

  final List<CityWeatherModel> cities;

  @override
  Future<List<CityWeatherModel>> fetchForecasts() async => cities;
}

class _FakeWeatherLocal implements WeatherLocalDataSource {
  List<CityWeatherModel>? stored;
  var writes = 0;

  @override
  Future<void> cacheForecasts(List<CityWeatherModel> forecasts) async {
    stored = forecasts;
    writes += 1;
  }

  @override
  Future<List<CityWeatherModel>?> readForecasts() async => stored;
}
