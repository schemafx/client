// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppAction _$AppActionFromJson(Map<String, dynamic> json) => _AppAction(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$AppActionTypeEnumMap, json['type']),
  config: json['config'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$AppActionToJson(_AppAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$AppActionTypeEnumMap[instance.type]!,
      'config': instance.config,
    };

const _$AppActionTypeEnumMap = {
  AppActionType.add: 'add',
  AppActionType.update: 'update',
  AppActionType.delete: 'delete',
  AppActionType.process: 'process',
};
