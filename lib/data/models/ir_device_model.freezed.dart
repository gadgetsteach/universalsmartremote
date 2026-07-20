// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ir_device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IrDeviceModel {

 int get id; String get category; String get brand; String get series; String get model; int get carrierFrequency; Map<String, List<int>> get buttons;
/// Create a copy of IrDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IrDeviceModelCopyWith<IrDeviceModel> get copyWith => _$IrDeviceModelCopyWithImpl<IrDeviceModel>(this as IrDeviceModel, _$identity);

  /// Serializes this IrDeviceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IrDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.series, series) || other.series == series)&&(identical(other.model, model) || other.model == model)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&const DeepCollectionEquality().equals(other.buttons, buttons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,brand,series,model,carrierFrequency,const DeepCollectionEquality().hash(buttons));

@override
String toString() {
  return 'IrDeviceModel(id: $id, category: $category, brand: $brand, series: $series, model: $model, carrierFrequency: $carrierFrequency, buttons: $buttons)';
}


}

/// @nodoc
abstract mixin class $IrDeviceModelCopyWith<$Res>  {
  factory $IrDeviceModelCopyWith(IrDeviceModel value, $Res Function(IrDeviceModel) _then) = _$IrDeviceModelCopyWithImpl;
@useResult
$Res call({
 int id, String category, String brand, String series, String model, int carrierFrequency, Map<String, List<int>> buttons
});




}
/// @nodoc
class _$IrDeviceModelCopyWithImpl<$Res>
    implements $IrDeviceModelCopyWith<$Res> {
  _$IrDeviceModelCopyWithImpl(this._self, this._then);

  final IrDeviceModel _self;
  final $Res Function(IrDeviceModel) _then;

/// Create a copy of IrDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? brand = null,Object? series = null,Object? model = null,Object? carrierFrequency = null,Object? buttons = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as int,buttons: null == buttons ? _self.buttons : buttons // ignore: cast_nullable_to_non_nullable
as Map<String, List<int>>,
  ));
}

}


/// Adds pattern-matching-related methods to [IrDeviceModel].
extension IrDeviceModelPatterns on IrDeviceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IrDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IrDeviceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IrDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _IrDeviceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IrDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _IrDeviceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String category,  String brand,  String series,  String model,  int carrierFrequency,  Map<String, List<int>> buttons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IrDeviceModel() when $default != null:
return $default(_that.id,_that.category,_that.brand,_that.series,_that.model,_that.carrierFrequency,_that.buttons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String category,  String brand,  String series,  String model,  int carrierFrequency,  Map<String, List<int>> buttons)  $default,) {final _that = this;
switch (_that) {
case _IrDeviceModel():
return $default(_that.id,_that.category,_that.brand,_that.series,_that.model,_that.carrierFrequency,_that.buttons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String category,  String brand,  String series,  String model,  int carrierFrequency,  Map<String, List<int>> buttons)?  $default,) {final _that = this;
switch (_that) {
case _IrDeviceModel() when $default != null:
return $default(_that.id,_that.category,_that.brand,_that.series,_that.model,_that.carrierFrequency,_that.buttons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IrDeviceModel implements IrDeviceModel {
  const _IrDeviceModel({required this.id, required this.category, required this.brand, required this.series, required this.model, required this.carrierFrequency, required final  Map<String, List<int>> buttons}): _buttons = buttons;
  factory _IrDeviceModel.fromJson(Map<String, dynamic> json) => _$IrDeviceModelFromJson(json);

@override final  int id;
@override final  String category;
@override final  String brand;
@override final  String series;
@override final  String model;
@override final  int carrierFrequency;
 final  Map<String, List<int>> _buttons;
@override Map<String, List<int>> get buttons {
  if (_buttons is EqualUnmodifiableMapView) return _buttons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_buttons);
}


/// Create a copy of IrDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IrDeviceModelCopyWith<_IrDeviceModel> get copyWith => __$IrDeviceModelCopyWithImpl<_IrDeviceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IrDeviceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IrDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.series, series) || other.series == series)&&(identical(other.model, model) || other.model == model)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&const DeepCollectionEquality().equals(other._buttons, _buttons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,brand,series,model,carrierFrequency,const DeepCollectionEquality().hash(_buttons));

@override
String toString() {
  return 'IrDeviceModel(id: $id, category: $category, brand: $brand, series: $series, model: $model, carrierFrequency: $carrierFrequency, buttons: $buttons)';
}


}

/// @nodoc
abstract mixin class _$IrDeviceModelCopyWith<$Res> implements $IrDeviceModelCopyWith<$Res> {
  factory _$IrDeviceModelCopyWith(_IrDeviceModel value, $Res Function(_IrDeviceModel) _then) = __$IrDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String category, String brand, String series, String model, int carrierFrequency, Map<String, List<int>> buttons
});




}
/// @nodoc
class __$IrDeviceModelCopyWithImpl<$Res>
    implements _$IrDeviceModelCopyWith<$Res> {
  __$IrDeviceModelCopyWithImpl(this._self, this._then);

  final _IrDeviceModel _self;
  final $Res Function(_IrDeviceModel) _then;

/// Create a copy of IrDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? brand = null,Object? series = null,Object? model = null,Object? carrierFrequency = null,Object? buttons = null,}) {
  return _then(_IrDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as int,buttons: null == buttons ? _self._buttons : buttons // ignore: cast_nullable_to_non_nullable
as Map<String, List<int>>,
  ));
}


}

// dart format on
