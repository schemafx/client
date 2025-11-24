// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSchema {

/// The unique identifier for this schema.
 String get id;/// The name of this schema.
 String get name;/// The list of tables in this schema.
 List<AppTable> get tables;/// The list of views in this schema.
 List<AppView> get views;
/// Create a copy of AppSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSchemaCopyWith<AppSchema> get copyWith => _$AppSchemaCopyWithImpl<AppSchema>(this as AppSchema, _$identity);

  /// Serializes this AppSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSchema&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tables, tables)&&const DeepCollectionEquality().equals(other.views, views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(tables),const DeepCollectionEquality().hash(views));

@override
String toString() {
  return 'AppSchema(id: $id, name: $name, tables: $tables, views: $views)';
}


}

/// @nodoc
abstract mixin class $AppSchemaCopyWith<$Res>  {
  factory $AppSchemaCopyWith(AppSchema value, $Res Function(AppSchema) _then) = _$AppSchemaCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<AppTable> tables, List<AppView> views
});




}
/// @nodoc
class _$AppSchemaCopyWithImpl<$Res>
    implements $AppSchemaCopyWith<$Res> {
  _$AppSchemaCopyWithImpl(this._self, this._then);

  final AppSchema _self;
  final $Res Function(AppSchema) _then;

/// Create a copy of AppSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tables = null,Object? views = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as List<AppTable>,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as List<AppView>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSchema].
extension AppSchemaPatterns on AppSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSchema value)  $default,){
final _that = this;
switch (_that) {
case _AppSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSchema value)?  $default,){
final _that = this;
switch (_that) {
case _AppSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<AppTable> tables,  List<AppView> views)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSchema() when $default != null:
return $default(_that.id,_that.name,_that.tables,_that.views);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<AppTable> tables,  List<AppView> views)  $default,) {final _that = this;
switch (_that) {
case _AppSchema():
return $default(_that.id,_that.name,_that.tables,_that.views);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<AppTable> tables,  List<AppView> views)?  $default,) {final _that = this;
switch (_that) {
case _AppSchema() when $default != null:
return $default(_that.id,_that.name,_that.tables,_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSchema extends AppSchema {
  const _AppSchema({required this.id, required this.name, final  List<AppTable> tables = const [], final  List<AppView> views = const []}): _tables = tables,_views = views,super._();
  factory _AppSchema.fromJson(Map<String, dynamic> json) => _$AppSchemaFromJson(json);

/// The unique identifier for this schema.
@override final  String id;
/// The name of this schema.
@override final  String name;
/// The list of tables in this schema.
 final  List<AppTable> _tables;
/// The list of tables in this schema.
@override@JsonKey() List<AppTable> get tables {
  if (_tables is EqualUnmodifiableListView) return _tables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tables);
}

/// The list of views in this schema.
 final  List<AppView> _views;
/// The list of views in this schema.
@override@JsonKey() List<AppView> get views {
  if (_views is EqualUnmodifiableListView) return _views;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_views);
}


/// Create a copy of AppSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSchemaCopyWith<_AppSchema> get copyWith => __$AppSchemaCopyWithImpl<_AppSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSchema&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._tables, _tables)&&const DeepCollectionEquality().equals(other._views, _views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_tables),const DeepCollectionEquality().hash(_views));

@override
String toString() {
  return 'AppSchema(id: $id, name: $name, tables: $tables, views: $views)';
}


}

/// @nodoc
abstract mixin class _$AppSchemaCopyWith<$Res> implements $AppSchemaCopyWith<$Res> {
  factory _$AppSchemaCopyWith(_AppSchema value, $Res Function(_AppSchema) _then) = __$AppSchemaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<AppTable> tables, List<AppView> views
});




}
/// @nodoc
class __$AppSchemaCopyWithImpl<$Res>
    implements _$AppSchemaCopyWith<$Res> {
  __$AppSchemaCopyWithImpl(this._self, this._then);

  final _AppSchema _self;
  final $Res Function(_AppSchema) _then;

/// Create a copy of AppSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tables = null,Object? views = null,}) {
  return _then(_AppSchema(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tables: null == tables ? _self._tables : tables // ignore: cast_nullable_to_non_nullable
as List<AppTable>,views: null == views ? _self._views : views // ignore: cast_nullable_to_non_nullable
as List<AppView>,
  ));
}


}

// dart format on
