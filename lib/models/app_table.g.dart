// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppTable _$AppTableFromJson(Map<String, dynamic> json) => _AppTable(
  id: json['id'] as String,
  name: json['name'] as String,
  connector: json['connector'] as String,
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map((e) => AppField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  actions:
      (json['actions'] as List<dynamic>?)
          ?.map((e) => AppAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  path:
      (json['path'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$AppTableToJson(_AppTable instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'connector': instance.connector,
  'fields': instance.fields,
  'actions': instance.actions,
  'path': instance.path,
};
