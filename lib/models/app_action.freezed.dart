// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppAction {

 String get id; String get name; AppActionType get type; Map<String, dynamic> get config;
/// Create a copy of AppAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppActionCopyWith<AppAction> get copyWith => _$AppActionCopyWithImpl<AppAction>(this as AppAction, _$identity);

  /// Serializes this AppAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppAction&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.config, config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'AppAction(id: $id, name: $name, type: $type, config: $config)';
}


}

/// @nodoc
abstract mixin class $AppActionCopyWith<$Res>  {
  factory $AppActionCopyWith(AppAction value, $Res Function(AppAction) _then) = _$AppActionCopyWithImpl;
@useResult
$Res call({
 String id, String name, AppActionType type, Map<String, dynamic> config
});




}
/// @nodoc
class _$AppActionCopyWithImpl<$Res>
    implements $AppActionCopyWith<$Res> {
  _$AppActionCopyWithImpl(this._self, this._then);

  final AppAction _self;
  final $Res Function(AppAction) _then;

/// Create a copy of AppAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? config = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppActionType,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppAction].
extension AppActionPatterns on AppAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppAction value)  $default,){
final _that = this;
switch (_that) {
case _AppAction():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppAction value)?  $default,){
final _that = this;
switch (_that) {
case _AppAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AppActionType type,  Map<String, dynamic> config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppAction() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AppActionType type,  Map<String, dynamic> config)  $default,) {final _that = this;
switch (_that) {
case _AppAction():
return $default(_that.id,_that.name,_that.type,_that.config);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AppActionType type,  Map<String, dynamic> config)?  $default,) {final _that = this;
switch (_that) {
case _AppAction() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.config);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppAction extends AppAction {
  const _AppAction({required this.id, required this.name, required this.type, final  Map<String, dynamic> config = const {}}): _config = config,super._();
  factory _AppAction.fromJson(Map<String, dynamic> json) => _$AppActionFromJson(json);

@override final  String id;
@override final  String name;
@override final  AppActionType type;
 final  Map<String, dynamic> _config;
@override@JsonKey() Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}


/// Create a copy of AppAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppActionCopyWith<_AppAction> get copyWith => __$AppActionCopyWithImpl<_AppAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppAction&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._config, _config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,const DeepCollectionEquality().hash(_config));

@override
String toString() {
  return 'AppAction(id: $id, name: $name, type: $type, config: $config)';
}


}

/// @nodoc
abstract mixin class _$AppActionCopyWith<$Res> implements $AppActionCopyWith<$Res> {
  factory _$AppActionCopyWith(_AppAction value, $Res Function(_AppAction) _then) = __$AppActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AppActionType type, Map<String, dynamic> config
});




}
/// @nodoc
class __$AppActionCopyWithImpl<$Res>
    implements _$AppActionCopyWith<$Res> {
  __$AppActionCopyWithImpl(this._self, this._then);

  final _AppAction _self;
  final $Res Function(_AppAction) _then;

/// Create a copy of AppAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? config = null,}) {
  return _then(_AppAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppActionType,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
