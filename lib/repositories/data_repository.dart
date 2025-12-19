import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

class DataRepository {
  final Ref ref;
  DataRepository(this.ref);
  late final _apiService = ApiService();

  Future<AppSchema?> loadSchema() async {
    try {
      final appId = ref.read(appIdProvider);
      if (appId == null) return null;

      return AppSchema.fromJson(await _apiService.get('apps/$appId/schema'));
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to load schema: $e');
      rethrow;
    }
  }

  Future<AppData> loadData({
    List<dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      final AppData appData = {};
      final appId = ref.read(appIdProvider);
      final schema = await loadSchema();

      if (appId == null || schema == null) return appData;

      (await Future.wait(
        schema.tables.map(
          (table) => _apiService.get(
            'apps/$appId/data/${table.id}',
            query: {
              if (filters != null || limit != null || offset != null)
                'query': jsonEncode({
                  if (filters != null) 'filters': filters,
                  if (limit != null) 'limit': limit,
                  if (offset != null) 'offset': offset,
                }),
            },
          ),
        ),
      )).asMap().forEach(
        (idx, data) => appData[schema.tables[idx].id] =
            List<Map<String, dynamic>>.from(data),
      );

      return appData;
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to load data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> loadTableData(
    String tableId, {
    List<dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      final appId = ref.read(appIdProvider);
      if (appId == null) return [];

      final data = await _apiService.get(
        'apps/$appId/data/$tableId',
        query: {
          if (filters != null || limit != null || offset != null)
            'query': jsonEncode({
              if (filters != null) 'filters': filters,
              if (limit != null) 'limit': limit,
              if (offset != null) 'offset': offset,
            }),
        },
      );

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      ref.read(errorProvider.notifier).showError(
        'Failed to load table data: $e',
      );
      rethrow;
    }
  }
}
