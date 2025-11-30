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

  Future<AppData> loadData() async {
    try {
      final AppData appData = {};
      final appId = ref.read(appIdProvider);
      final schema = await loadSchema();

      if (appId == null || schema == null) return appData;

      (await Future.wait(
        schema.tables.map(
          (table) => _apiService.get('apps/$appId/data/${table.id}'),
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
}
