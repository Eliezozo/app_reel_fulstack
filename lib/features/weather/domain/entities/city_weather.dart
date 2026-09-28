class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.weatherCode,
    required this.precipitation,
  });

  final String date;
  final double tempMin;
  final double tempMax;
  final int weatherCode;
  final double precipitation;
}

class CityWeather {
  const CityWeather({
    required this.id,
    required this.city,
    required this.region,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.description,
    required this.precipitation,
    required this.estimated,
    required this.daily,
  });

  final String id;
  final String city;
  final String region;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final String description;
  final double precipitation;
  final bool estimated;
  final List<DailyForecast> daily;
}
