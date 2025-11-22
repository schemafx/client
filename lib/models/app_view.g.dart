// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppView _$AppViewFromJson(Map<String, dynamic> json) => _AppView(
  id: json['id'] as String,
  name: json['name'] as String,
  tableId: json['tableId'] as String,
  type: $enumDecode(_$AppViewTypeEnumMap, json['type']),
  fields: (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$AppViewToJson(_AppView instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'tableId': instance.tableId,
  'type': _$AppViewTypeEnumMap[instance.type]!,
  'fields': instance.fields,
};

const _$AppViewTypeEnumMap = {
  AppViewType.table: 'table',
  AppViewType.form: 'form',
};
