import '../../../../core/json/number_converters.dart';
import '../../domain/entities/city_weather.dart';

class DailyForecastModel {
  const DailyForecastModel({
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

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: json['date'] as String,
      tempMin: const AsDouble().fromJson(json['tempMin']),
      tempMax: const AsDouble().fromJson(json['tempMax']),
      weatherCode: const AsInt().fromJson(json['weatherCode']),
      precipitation: const AsDouble().fromJson(json['precipitation']),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'tempMin': tempMin,
        'tempMax': tempMax,
        'weatherCode': weatherCode,
        'precipitation': precipitation,
      };

  DailyForecast toEntity() => DailyForecast(
        date: date,
        tempMin: tempMin,
        tempMax: tempMax,
        weatherCode: weatherCode,
        precipitation: precipitation,
      );
}

class CityWeatherModel {
  const CityWeatherModel({
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
  final List<DailyForecastModel> daily;

  factory CityWeatherModel.fromJson(Map<String, dynamic> json) {
    final rawDaily = json['daily'];
    if (rawDaily is! List) {
      throw const FormatException('Liste de prévisions attendue');
    }
    return CityWeatherModel(
      id: json['id'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      temperature: const AsDouble().fromJson(json['temperature']),
      humidity: const AsInt().fromJson(json['humidity']),
      windSpeed: const AsDouble().fromJson(json['windSpeed']),
      weatherCode: const AsInt().fromJson(json['weatherCode']),
      description: json['description'] as String,
      precipitation: const AsDouble().fromJson(json['precipitation']),
      estimated: json['estimated'] == true,
      daily: rawDaily.map((item) {
        if (item is! Map) throw const FormatException('Prévision illisible');
        return DailyForecastModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'city': city,
        'region': region,
        'temperature': temperature,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'weatherCode': weatherCode,
        'description': description,
        'precipitation': precipitation,
        'estimated': estimated,
        'daily': daily.map((day) => day.toJson()).toList(),
      };

  CityWeather toEntity() => CityWeather(
        id: id,
        city: city,
        region: region,
        temperature: temperature,
        humidity: humidity,
        windSpeed: windSpeed,
        weatherCode: weatherCode,
        description: description,
        precipitation: precipitation,
        estimated: estimated,
        daily: daily.map((day) => day.toEntity()).toList(growable: false),
      );
}
