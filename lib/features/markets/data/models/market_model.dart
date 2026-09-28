import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/json/number_converters.dart';
import '../../domain/entities/market.dart';

part 'market_model.freezed.dart';
part 'market_model.g.dart';

@freezed
abstract class MarketModel with _$MarketModel {
  const factory MarketModel({
    required String id,
    required String crop,
    required String market,
    required String unit,
    @AsDouble() required double price,
    required String currency,
    @AsDouble() required double changePercent,
    required String updatedAt,
  }) = _MarketModel;

  factory MarketModel.fromJson(Map<String, dynamic> json) => _$MarketModelFromJson(json);
}

extension MarketModelMapper on MarketModel {
  Market toEntity() => Market(
        id: id,
        crop: crop,
        market: market,
        unit: unit,
        price: price,
        currency: currency,
        changePercent: changePercent,
        updatedAt: updatedAt,
      );
}
