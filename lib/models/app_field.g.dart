// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppField _$AppFieldFromJson(Map<String, dynamic> json) => _AppField(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$AppFieldTypeEnumMap, json['type']),
  referenceTo: json['referenceTo'] as String?,
  isRequired: json['isRequired'] as bool? ?? false,
  minLength: (json['minLength'] as num?)?.toInt(),
  maxLength: (json['maxLength'] as num?)?.toInt(),
  minValue: (json['minValue'] as num?)?.toDouble(),
  maxValue: (json['maxValue'] as num?)?.toDouble(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AppFieldToJson(_AppField instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$AppFieldTypeEnumMap[instance.type]!,
  'referenceTo': instance.referenceTo,
  'isRequired': instance.isRequired,
  'minLength': instance.minLength,
  'maxLength': instance.maxLength,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'options': instance.options,
};

const _$AppFieldTypeEnumMap = {
  AppFieldType.text: 'text',
  AppFieldType.number: 'number',
  AppFieldType.date: 'date',
  AppFieldType.email: 'email',
  AppFieldType.dropdown: 'dropdown',
  AppFieldType.boolean: 'boolean',
  AppFieldType.reference: 'reference',
};
