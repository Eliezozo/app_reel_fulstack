// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsArticleModel {

 String get id; String get title; String get summary; String get body; String get category; String get source; String get publishedAt;
/// Create a copy of NewsArticleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsArticleModelCopyWith<NewsArticleModel> get copyWith => _$NewsArticleModelCopyWithImpl<NewsArticleModel>(this as NewsArticleModel, _$identity);

  /// Serializes this NewsArticleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsArticleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.category, category) || other.category == category)&&(identical(other.source, source) || other.source == source)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,summary,body,category,source,publishedAt);

@override
String toString() {
  return 'NewsArticleModel(id: $id, title: $title, summary: $summary, body: $body, category: $category, source: $source, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $NewsArticleModelCopyWith<$Res>  {
  factory $NewsArticleModelCopyWith(NewsArticleModel value, $Res Function(NewsArticleModel) _then) = _$NewsArticleModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String summary, String body, String category, String source, String publishedAt
});




}
/// @nodoc
class _$NewsArticleModelCopyWithImpl<$Res>
    implements $NewsArticleModelCopyWith<$Res> {
  _$NewsArticleModelCopyWithImpl(this._self, this._then);

  final NewsArticleModel _self;
  final $Res Function(NewsArticleModel) _then;

/// Create a copy of NewsArticleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? body = null,Object? category = null,Object? source = null,Object? publishedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsArticleModel].
extension NewsArticleModelPatterns on NewsArticleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsArticleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsArticleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsArticleModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsArticleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsArticleModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsArticleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  String body,  String category,  String source,  String publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsArticleModel() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.body,_that.category,_that.source,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  String body,  String category,  String source,  String publishedAt)  $default,) {final _that = this;
switch (_that) {
case _NewsArticleModel():
return $default(_that.id,_that.title,_that.summary,_that.body,_that.category,_that.source,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String summary,  String body,  String category,  String source,  String publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _NewsArticleModel() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.body,_that.category,_that.source,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsArticleModel implements NewsArticleModel {
  const _NewsArticleModel({required this.id, required this.title, required this.summary, required this.body, required this.category, required this.source, required this.publishedAt});
  factory _NewsArticleModel.fromJson(Map<String, dynamic> json) => _$NewsArticleModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String summary;
@override final  String body;
@override final  String category;
@override final  String source;
@override final  String publishedAt;

/// Create a copy of NewsArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsArticleModelCopyWith<_NewsArticleModel> get copyWith => __$NewsArticleModelCopyWithImpl<_NewsArticleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsArticleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsArticleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.category, category) || other.category == category)&&(identical(other.source, source) || other.source == source)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,summary,body,category,source,publishedAt);

@override
String toString() {
  return 'NewsArticleModel(id: $id, title: $title, summary: $summary, body: $body, category: $category, source: $source, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$NewsArticleModelCopyWith<$Res> implements $NewsArticleModelCopyWith<$Res> {
  factory _$NewsArticleModelCopyWith(_NewsArticleModel value, $Res Function(_NewsArticleModel) _then) = __$NewsArticleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String summary, String body, String category, String source, String publishedAt
});




}
/// @nodoc
class __$NewsArticleModelCopyWithImpl<$Res>
    implements _$NewsArticleModelCopyWith<$Res> {
  __$NewsArticleModelCopyWithImpl(this._self, this._then);

  final _NewsArticleModel _self;
  final $Res Function(_NewsArticleModel) _then;

/// Create a copy of NewsArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? body = null,Object? category = null,Object? source = null,Object? publishedAt = null,}) {
  return _then(_NewsArticleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
