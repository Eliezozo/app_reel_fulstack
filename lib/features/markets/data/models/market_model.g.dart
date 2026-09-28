// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketModel _$MarketModelFromJson(Map<String, dynamic> json) => _MarketModel(
  id: json['id'] as String,
  crop: json['crop'] as String,
  market: json['market'] as String,
  unit: json['unit'] as String,
  price: const AsDouble().fromJson(json['price']),
  currency: json['currency'] as String,
  changePercent: const AsDouble().fromJson(json['changePercent']),
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$MarketModelToJson(_MarketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crop': instance.crop,
      'market': instance.market,
      'unit': instance.unit,
      'price': const AsDouble().toJson(instance.price),
      'currency': instance.currency,
      'changePercent': const AsDouble().toJson(instance.changePercent),
      'updatedAt': instance.updatedAt,
    };
