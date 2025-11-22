import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/services/shared_preferences_storage_service.dart';
import 'package:schemafx/services/storage_service.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

const String _appDataKey = 'app_data';

final storageServiceProvider = Provider<StorageService>(
  (ref) => SharedPreferencesStorageService(),
);

class DataRepository {
  final Ref ref;
  final StorageService _storageService;
  DataRepository(this.ref) : _storageService = ref.read(storageServiceProvider);

  Future<Map<String, dynamic>?> _loadAppData() =>
      _storageService.load(_appDataKey);

  Future<AppSchema?> loadSchema() async {
    try {
      final appData = await _loadAppData();

      if (appData == null || !appData.containsKey('schema')) return null;
      return AppSchema.fromJson(appData['schema']);
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to load schema: $e');
      rethrow;
    }
  }

  Future<AppData?> loadData() async {
    try {
      final appData = await _loadAppData();
      if (appData == null || !appData.containsKey('data')) return null;

      return appData['data'].map(
        (tableId, List rows) => MapEntry(
          tableId,
          rows.map((row) => Map<String, dynamic>.from(row)).toList(),
        ),
      );
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to load data: $e');
      rethrow;
    }
  }

  /// Saves the application [schema] to storage.
  Future<void> saveSchema(AppSchema schema) async {
    try {
      final appData = await _loadAppData() ?? {};
      appData['schema'] = schema.toJson();

      await _storageService.save(_appDataKey, appData);
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to save schema: $e');
      rethrow;
    }
  }

  Future<void> saveData(AppData data) async {
    try {
      final appData = await _loadAppData() ?? {};
      appData['data'] = data;

      await _storageService.save(_appDataKey, appData);
    } catch (e) {
      ref.read(errorProvider.notifier).showError('Failed to save data: $e');
      rethrow;
    }
  }
}
