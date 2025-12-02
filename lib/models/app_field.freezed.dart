// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppField {

 String get id; String get name; AppFieldType get type; String? get referenceTo; bool get isRequired; int? get minLength; int? get maxLength; double? get minValue; double? get maxValue; DateTime? get startDate; DateTime? get endDate; List<String>? get options; List<AppField>? get fields; AppField? get child;
/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppFieldCopyWith<AppField> get copyWith => _$AppFieldCopyWithImpl<AppField>(this as AppField, _$identity);

  /// Serializes this AppField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppField&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceTo, referenceTo) || other.referenceTo == referenceTo)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.child, child) || other.child == child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,referenceTo,isRequired,minLength,maxLength,minValue,maxValue,startDate,endDate,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(fields),child);

@override
String toString() {
  return 'AppField(id: $id, name: $name, type: $type, referenceTo: $referenceTo, isRequired: $isRequired, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, startDate: $startDate, endDate: $endDate, options: $options, fields: $fields, child: $child)';
}


}

/// @nodoc
abstract mixin class $AppFieldCopyWith<$Res>  {
  factory $AppFieldCopyWith(AppField value, $Res Function(AppField) _then) = _$AppFieldCopyWithImpl;
@useResult
$Res call({
 String id, String name, AppFieldType type, String? referenceTo, bool isRequired, int? minLength, int? maxLength, double? minValue, double? maxValue, DateTime? startDate, DateTime? endDate, List<String>? options, List<AppField>? fields, AppField? child
});


$AppFieldCopyWith<$Res>? get child;

}
/// @nodoc
class _$AppFieldCopyWithImpl<$Res>
    implements $AppFieldCopyWith<$Res> {
  _$AppFieldCopyWithImpl(this._self, this._then);

  final AppField _self;
  final $Res Function(AppField) _then;

/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? referenceTo = freezed,Object? isRequired = null,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? options = freezed,Object? fields = freezed,Object? child = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppFieldType,referenceTo: freezed == referenceTo ? _self.referenceTo : referenceTo // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<AppField>?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as AppField?,
  ));
}
/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFieldCopyWith<$Res>? get child {
    if (_self.child == null) {
    return null;
  }

  return $AppFieldCopyWith<$Res>(_self.child!, (value) {
    return _then(_self.copyWith(child: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppField].
extension AppFieldPatterns on AppField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppField value)  $default,){
final _that = this;
switch (_that) {
case _AppField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppField value)?  $default,){
final _that = this;
switch (_that) {
case _AppField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AppFieldType type,  String? referenceTo,  bool isRequired,  int? minLength,  int? maxLength,  double? minValue,  double? maxValue,  DateTime? startDate,  DateTime? endDate,  List<String>? options,  List<AppField>? fields,  AppField? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppField() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.referenceTo,_that.isRequired,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.startDate,_that.endDate,_that.options,_that.fields,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AppFieldType type,  String? referenceTo,  bool isRequired,  int? minLength,  int? maxLength,  double? minValue,  double? maxValue,  DateTime? startDate,  DateTime? endDate,  List<String>? options,  List<AppField>? fields,  AppField? child)  $default,) {final _that = this;
switch (_that) {
case _AppField():
return $default(_that.id,_that.name,_that.type,_that.referenceTo,_that.isRequired,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.startDate,_that.endDate,_that.options,_that.fields,_that.child);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AppFieldType type,  String? referenceTo,  bool isRequired,  int? minLength,  int? maxLength,  double? minValue,  double? maxValue,  DateTime? startDate,  DateTime? endDate,  List<String>? options,  List<AppField>? fields,  AppField? child)?  $default,) {final _that = this;
switch (_that) {
case _AppField() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.referenceTo,_that.isRequired,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.startDate,_that.endDate,_that.options,_that.fields,_that.child);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppField extends AppField {
  const _AppField({required this.id, required this.name, required this.type, this.referenceTo, this.isRequired = false, this.minLength, this.maxLength, this.minValue, this.maxValue, this.startDate, this.endDate, final  List<String>? options, final  List<AppField>? fields, this.child}): _options = options,_fields = fields,super._();
  factory _AppField.fromJson(Map<String, dynamic> json) => _$AppFieldFromJson(json);

@override final  String id;
@override final  String name;
@override final  AppFieldType type;
@override final  String? referenceTo;
@override@JsonKey() final  bool isRequired;
@override final  int? minLength;
@override final  int? maxLength;
@override final  double? minValue;
@override final  double? maxValue;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AppField>? _fields;
@override List<AppField>? get fields {
  final value = _fields;
  if (value == null) return null;
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  AppField? child;

/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppFieldCopyWith<_AppField> get copyWith => __$AppFieldCopyWithImpl<_AppField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppField&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceTo, referenceTo) || other.referenceTo == referenceTo)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.child, child) || other.child == child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,referenceTo,isRequired,minLength,maxLength,minValue,maxValue,startDate,endDate,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_fields),child);

@override
String toString() {
  return 'AppField(id: $id, name: $name, type: $type, referenceTo: $referenceTo, isRequired: $isRequired, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, startDate: $startDate, endDate: $endDate, options: $options, fields: $fields, child: $child)';
}


}

/// @nodoc
abstract mixin class _$AppFieldCopyWith<$Res> implements $AppFieldCopyWith<$Res> {
  factory _$AppFieldCopyWith(_AppField value, $Res Function(_AppField) _then) = __$AppFieldCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AppFieldType type, String? referenceTo, bool isRequired, int? minLength, int? maxLength, double? minValue, double? maxValue, DateTime? startDate, DateTime? endDate, List<String>? options, List<AppField>? fields, AppField? child
});


@override $AppFieldCopyWith<$Res>? get child;

}
/// @nodoc
class __$AppFieldCopyWithImpl<$Res>
    implements _$AppFieldCopyWith<$Res> {
  __$AppFieldCopyWithImpl(this._self, this._then);

  final _AppField _self;
  final $Res Function(_AppField) _then;

/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? referenceTo = freezed,Object? isRequired = null,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? options = freezed,Object? fields = freezed,Object? child = freezed,}) {
  return _then(_AppField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppFieldType,referenceTo: freezed == referenceTo ? _self.referenceTo : referenceTo // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,fields: freezed == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<AppField>?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as AppField?,
  ));
}

/// Create a copy of AppField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFieldCopyWith<$Res>? get child {
    if (_self.child == null) {
    return null;
  }

  return $AppFieldCopyWith<$Res>(_self.child!, (value) {
    return _then(_self.copyWith(child: value));
  });
}
}

// dart format on
