import 'package:freezed_annotation/freezed_annotation.dart';

class AsDouble implements JsonConverter<double, Object?> {
  const AsDouble();

  @override
  double fromJson(Object? value) {
    if (value is num) return value.toDouble();
    throw const FormatException('Nombre attendu');
  }

  @override
  double toJson(double object) => object;
}

class AsInt implements JsonConverter<int, Object?> {
  const AsInt();

  @override
  int fromJson(Object? value) {
    if (value is num) return value.round();
    throw const FormatException('Entier attendu');
  }

  @override
  int toJson(int object) => object;
}
