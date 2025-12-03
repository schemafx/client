import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/application_providers.dart';
import 'package:schemafx/providers/base_notifier.dart';
import 'package:schemafx/repositories/data_repository.dart';
import 'package:schemafx/services/api_service.dart';

/// A type definition for the application's data.
///
/// It's a map where the key is the table ID and the value is a list of rows.
/// Each row is a map where the key is the field ID and the value is the cell content.
typedef AppData = Map<String, List<Map<String, dynamic>>>;

/// A notifier that manages the application's data.
///
/// This notifier is responsible for loading, saving, and modifying the [AppData]
/// which includes all the rows for all the tables.
class DataNotifier extends BaseNotifier<AppData?> {
  late final _repo = DataRepository(ref);
  late final _apiService = ApiService();

  @override
  Future<AppData?> build() async {
    final appId = ref.watch(appIdProvider);
    if (appId == null) return null;
    return await _repo.loadData();
  }

  /// Adds a [row] to the table with the given [tableId].
  Future<void> executeAction(
    String tableId,
    String actionId,
    List<Map<String, dynamic>> rows, {
    Map<String, dynamic>? payload,
  }) async {
    final newState = {...(await future ?? {})};
    newState[tableId] = List<Map<String, dynamic>>.from(
      await _apiService.post('apps/${ref.read(appIdProvider)}/data/$tableId', {
        'actionId': actionId,
        'rows': rows,
        'payload': payload,
      }),
    );

    return mutate(() async => newState, 'Saved');
  }
}

/// A provider that exposes the application's data and allows it to be modified.
final dataProvider = AsyncNotifierProvider<DataNotifier, AppData?>(
  DataNotifier.new,
);

/// A provider that returns a single record by its ID.
///
/// The `family` modifier is used to pass the table and record IDs to the provider.
final recordByIdProvider =
    Provider.family<Map<String, dynamic>?, ({String tableId, String recordId})>(
      (ref, ids) => ref
          .watch(dataProvider)
          .when(
            data: (allData) {
              final records = allData?[ids.tableId] ?? [];

              try {
                return records.firstWhere((r) => r['_id'] == ids.recordId);
              } catch (e) {
                return null;
              }
            },
            loading: () => null,
            error: (_, _) => null,
          ),
    );
