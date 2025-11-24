// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppView {

/// The unique identifier of the view.
 String get id;/// The name of the view.
 String get name;/// The unique identifier of the table this view is associated with.
 String get tableId;/// The type of view to display.
 AppViewType get type;/// The list of field IDs to display in the view.
 List<String> get fields;
/// Create a copy of AppView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppViewCopyWith<AppView> get copyWith => _$AppViewCopyWithImpl<AppView>(this as AppView, _$identity);

  /// Serializes this AppView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppView&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.fields, fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tableId,type,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'AppView(id: $id, name: $name, tableId: $tableId, type: $type, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $AppViewCopyWith<$Res>  {
  factory $AppViewCopyWith(AppView value, $Res Function(AppView) _then) = _$AppViewCopyWithImpl;
@useResult
$Res call({
 String id, String name, String tableId, AppViewType type, List<String> fields
});




}
/// @nodoc
class _$AppViewCopyWithImpl<$Res>
    implements $AppViewCopyWith<$Res> {
  _$AppViewCopyWithImpl(this._self, this._then);

  final AppView _self;
  final $Res Function(AppView) _then;

/// Create a copy of AppView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tableId = null,Object? type = null,Object? fields = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppViewType,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppView].
extension AppViewPatterns on AppView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppView value)  $default,){
final _that = this;
switch (_that) {
case _AppView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppView value)?  $default,){
final _that = this;
switch (_that) {
case _AppView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String tableId,  AppViewType type,  List<String> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppView() when $default != null:
return $default(_that.id,_that.name,_that.tableId,_that.type,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String tableId,  AppViewType type,  List<String> fields)  $default,) {final _that = this;
switch (_that) {
case _AppView():
return $default(_that.id,_that.name,_that.tableId,_that.type,_that.fields);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String tableId,  AppViewType type,  List<String> fields)?  $default,) {final _that = this;
switch (_that) {
case _AppView() when $default != null:
return $default(_that.id,_that.name,_that.tableId,_that.type,_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppView extends AppView {
  const _AppView({required this.id, required this.name, required this.tableId, required this.type, required final  List<String> fields}): _fields = fields,super._();
  factory _AppView.fromJson(Map<String, dynamic> json) => _$AppViewFromJson(json);

/// The unique identifier of the view.
@override final  String id;
/// The name of the view.
@override final  String name;
/// The unique identifier of the table this view is associated with.
@override final  String tableId;
/// The type of view to display.
@override final  AppViewType type;
/// The list of field IDs to display in the view.
 final  List<String> _fields;
/// The list of field IDs to display in the view.
@override List<String> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of AppView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppViewCopyWith<_AppView> get copyWith => __$AppViewCopyWithImpl<_AppView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppView&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tableId,type,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'AppView(id: $id, name: $name, tableId: $tableId, type: $type, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$AppViewCopyWith<$Res> implements $AppViewCopyWith<$Res> {
  factory _$AppViewCopyWith(_AppView value, $Res Function(_AppView) _then) = __$AppViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String tableId, AppViewType type, List<String> fields
});




}
/// @nodoc
class __$AppViewCopyWithImpl<$Res>
    implements _$AppViewCopyWith<$Res> {
  __$AppViewCopyWithImpl(this._self, this._then);

  final _AppView _self;
  final $Res Function(_AppView) _then;

/// Create a copy of AppView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tableId = null,Object? type = null,Object? fields = null,}) {
  return _then(_AppView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppViewType,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
