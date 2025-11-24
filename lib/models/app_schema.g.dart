// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSchema _$AppSchemaFromJson(Map<String, dynamic> json) => _AppSchema(
  id: json['id'] as String,
  name: json['name'] as String,
  tables:
      (json['tables'] as List<dynamic>?)
          ?.map((e) => AppTable.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  views:
      (json['views'] as List<dynamic>?)
          ?.map((e) => AppView.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AppSchemaToJson(_AppSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tables': instance.tables,
      'views': instance.views,
    };
