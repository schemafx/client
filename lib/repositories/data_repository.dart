import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/services/shared_preferences_storage_service.dart';
import 'package:schemafx/services/storage_service.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => SharedPreferencesStorageService(),
);

class DataRepository {
  final Ref ref;
  DataRepository(this.ref);
  late final _apiService = ApiService();

  Future<AppSchema> loadSchema() async {
    try {
      return AppSchema.fromJson(await _apiService.get('apps/appId/schema'));
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to load schema: $e');
      rethrow;
    }
  }

  Future<AppData> loadData() async {
    try {
      final AppData appData = {};
      final schema = await loadSchema();

      (await Future.wait(
        schema.tables.map(
          (table) => _apiService.get('apps/appId/data/${table.id}'),
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
