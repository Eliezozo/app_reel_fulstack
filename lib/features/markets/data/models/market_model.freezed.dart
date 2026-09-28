// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketModel {

 String get id; String get crop; String get market; String get unit;@AsDouble() double get price; String get currency;@AsDouble() double get changePercent; String get updatedAt;
/// Create a copy of MarketModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketModelCopyWith<MarketModel> get copyWith => _$MarketModelCopyWithImpl<MarketModel>(this as MarketModel, _$identity);

  /// Serializes this MarketModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketModel&&(identical(other.id, id) || other.id == id)&&(identical(other.crop, crop) || other.crop == crop)&&(identical(other.market, market) || other.market == market)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,crop,market,unit,price,currency,changePercent,updatedAt);

@override
String toString() {
  return 'MarketModel(id: $id, crop: $crop, market: $market, unit: $unit, price: $price, currency: $currency, changePercent: $changePercent, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MarketModelCopyWith<$Res>  {
  factory $MarketModelCopyWith(MarketModel value, $Res Function(MarketModel) _then) = _$MarketModelCopyWithImpl;
@useResult
$Res call({
 String id, String crop, String market, String unit,@AsDouble() double price, String currency,@AsDouble() double changePercent, String updatedAt
});




}
/// @nodoc
class _$MarketModelCopyWithImpl<$Res>
    implements $MarketModelCopyWith<$Res> {
  _$MarketModelCopyWithImpl(this._self, this._then);

  final MarketModel _self;
  final $Res Function(MarketModel) _then;

/// Create a copy of MarketModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? crop = null,Object? market = null,Object? unit = null,Object? price = null,Object? currency = null,Object? changePercent = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,crop: null == crop ? _self.crop : crop // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketModel].
extension MarketModelPatterns on MarketModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketModel value)  $default,){
final _that = this;
switch (_that) {
case _MarketModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketModel value)?  $default,){
final _that = this;
switch (_that) {
case _MarketModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String crop,  String market,  String unit, @AsDouble()  double price,  String currency, @AsDouble()  double changePercent,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketModel() when $default != null:
return $default(_that.id,_that.crop,_that.market,_that.unit,_that.price,_that.currency,_that.changePercent,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String crop,  String market,  String unit, @AsDouble()  double price,  String currency, @AsDouble()  double changePercent,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MarketModel():
return $default(_that.id,_that.crop,_that.market,_that.unit,_that.price,_that.currency,_that.changePercent,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String crop,  String market,  String unit, @AsDouble()  double price,  String currency, @AsDouble()  double changePercent,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MarketModel() when $default != null:
return $default(_that.id,_that.crop,_that.market,_that.unit,_that.price,_that.currency,_that.changePercent,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketModel implements MarketModel {
  const _MarketModel({required this.id, required this.crop, required this.market, required this.unit, @AsDouble() required this.price, required this.currency, @AsDouble() required this.changePercent, required this.updatedAt});
  factory _MarketModel.fromJson(Map<String, dynamic> json) => _$MarketModelFromJson(json);

@override final  String id;
@override final  String crop;
@override final  String market;
@override final  String unit;
@override@AsDouble() final  double price;
@override final  String currency;
@override@AsDouble() final  double changePercent;
@override final  String updatedAt;

/// Create a copy of MarketModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketModelCopyWith<_MarketModel> get copyWith => __$MarketModelCopyWithImpl<_MarketModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketModel&&(identical(other.id, id) || other.id == id)&&(identical(other.crop, crop) || other.crop == crop)&&(identical(other.market, market) || other.market == market)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,crop,market,unit,price,currency,changePercent,updatedAt);

@override
String toString() {
  return 'MarketModel(id: $id, crop: $crop, market: $market, unit: $unit, price: $price, currency: $currency, changePercent: $changePercent, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MarketModelCopyWith<$Res> implements $MarketModelCopyWith<$Res> {
  factory _$MarketModelCopyWith(_MarketModel value, $Res Function(_MarketModel) _then) = __$MarketModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String crop, String market, String unit,@AsDouble() double price, String currency,@AsDouble() double changePercent, String updatedAt
});




}
/// @nodoc
class __$MarketModelCopyWithImpl<$Res>
    implements _$MarketModelCopyWith<$Res> {
  __$MarketModelCopyWithImpl(this._self, this._then);

  final _MarketModel _self;
  final $Res Function(_MarketModel) _then;

/// Create a copy of MarketModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? crop = null,Object? market = null,Object? unit = null,Object? price = null,Object? currency = null,Object? changePercent = null,Object? updatedAt = null,}) {
  return _then(_MarketModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,crop: null == crop ? _self.crop : crop // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
