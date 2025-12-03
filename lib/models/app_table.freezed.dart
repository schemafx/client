// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppTable {

 String get id; String get name; String get connector; List<AppField> get fields; List<AppAction> get actions;
/// Create a copy of AppTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTableCopyWith<AppTable> get copyWith => _$AppTableCopyWithImpl<AppTable>(this as AppTable, _$identity);

  /// Serializes this AppTable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connector, connector) || other.connector == connector)&&const DeepCollectionEquality().equals(other.fields, fields)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,connector,const DeepCollectionEquality().hash(fields),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'AppTable(id: $id, name: $name, connector: $connector, fields: $fields, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $AppTableCopyWith<$Res>  {
  factory $AppTableCopyWith(AppTable value, $Res Function(AppTable) _then) = _$AppTableCopyWithImpl;
@useResult
$Res call({
 String id, String name, String connector, List<AppField> fields, List<AppAction> actions
});




}
/// @nodoc
class _$AppTableCopyWithImpl<$Res>
    implements $AppTableCopyWith<$Res> {
  _$AppTableCopyWithImpl(this._self, this._then);

  final AppTable _self;
  final $Res Function(AppTable) _then;

/// Create a copy of AppTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? connector = null,Object? fields = null,Object? actions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connector: null == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<AppField>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AppAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppTable].
extension AppTablePatterns on AppTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppTable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppTable value)  $default,){
final _that = this;
switch (_that) {
case _AppTable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppTable value)?  $default,){
final _that = this;
switch (_that) {
case _AppTable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String connector,  List<AppField> fields,  List<AppAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppTable() when $default != null:
return $default(_that.id,_that.name,_that.connector,_that.fields,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String connector,  List<AppField> fields,  List<AppAction> actions)  $default,) {final _that = this;
switch (_that) {
case _AppTable():
return $default(_that.id,_that.name,_that.connector,_that.fields,_that.actions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String connector,  List<AppField> fields,  List<AppAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _AppTable() when $default != null:
return $default(_that.id,_that.name,_that.connector,_that.fields,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppTable extends AppTable {
  const _AppTable({required this.id, required this.name, required this.connector, final  List<AppField> fields = const [], final  List<AppAction> actions = const []}): _fields = fields,_actions = actions,super._();
  factory _AppTable.fromJson(Map<String, dynamic> json) => _$AppTableFromJson(json);

@override final  String id;
@override final  String name;
@override final  String connector;
 final  List<AppField> _fields;
@override@JsonKey() List<AppField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

 final  List<AppAction> _actions;
@override@JsonKey() List<AppAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}


/// Create a copy of AppTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppTableCopyWith<_AppTable> get copyWith => __$AppTableCopyWithImpl<_AppTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppTableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppTable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connector, connector) || other.connector == connector)&&const DeepCollectionEquality().equals(other._fields, _fields)&&const DeepCollectionEquality().equals(other._actions, _actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,connector,const DeepCollectionEquality().hash(_fields),const DeepCollectionEquality().hash(_actions));

@override
String toString() {
  return 'AppTable(id: $id, name: $name, connector: $connector, fields: $fields, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$AppTableCopyWith<$Res> implements $AppTableCopyWith<$Res> {
  factory _$AppTableCopyWith(_AppTable value, $Res Function(_AppTable) _then) = __$AppTableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String connector, List<AppField> fields, List<AppAction> actions
});




}
/// @nodoc
class __$AppTableCopyWithImpl<$Res>
    implements _$AppTableCopyWith<$Res> {
  __$AppTableCopyWithImpl(this._self, this._then);

  final _AppTable _self;
  final $Res Function(_AppTable) _then;

/// Create a copy of AppTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? connector = null,Object? fields = null,Object? actions = null,}) {
  return _then(_AppTable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connector: null == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<AppField>,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<AppAction>,
  ));
}


}

// dart format on
