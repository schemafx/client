import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/base_notifier.dart';
import 'package:schemafx/repositories/data_repository.dart';

/// A type definition for the application's data.
///
/// It's a map where the key is the table ID and the value is a list of rows.
/// Each row is a map where the key is the field ID and the value is the cell content.
typedef AppData = Map<String, List<Map<String, dynamic>>>;

/// A notifier that manages the application's data.
///
/// This notifier is responsible for loading, saving, and modifying the [AppData]
/// which includes all the rows for all the tables.
class DataNotifier extends BaseNotifier<AppData> {
  late final _repo = DataRepository(ref);

  @override
  Future<AppData> build() async {
    return await _repo.loadData() ?? {};
  }

  /// Adds a [row] to the table with the given [tableId].
  Future<void> addRow(String tableId, Map<String, dynamic> row) async {
    final oldState = await future;
    final newState = {...oldState};
    if (!newState.containsKey(tableId)) {
      newState[tableId] = [];
    }

    newState[tableId]!.add(row);

    await mutate(() async {
      await _repo.saveData(newState);
      return newState;
    }, 'Row added successfully');
  }

  /// Updates the [row] at the given [rowIndex] in the table with the given [tableId].
  Future<void> updateRow(
    String tableId,
    int rowIndex,
    Map<String, dynamic> row,
  ) async {
    final oldState = await future;
    final newState = {...oldState};

    if (newState.containsKey(tableId) && newState[tableId]!.length > rowIndex) {
      newState[tableId]![rowIndex] = row;

      await mutate(() async {
        await _repo.saveData(newState);
        return newState;
      }, 'Row updated successfully');
    }
  }

  /// Deletes the row at the given [rowIndex] from the table with the given [tableId].
  Future<void> deleteRow(String tableId, int rowIndex) async {
    final oldState = await future;
    final newState = {...oldState};

    if (newState.containsKey(tableId) && newState[tableId]!.length > rowIndex) {
      newState[tableId]!.removeAt(rowIndex);

      await mutate(() async {
        await _repo.saveData(newState);
        return newState;
      }, 'Row deleted successfully');
    }
  }
}

/// A provider that exposes the application's data and allows it to be modified.
final dataProvider = AsyncNotifierProvider<DataNotifier, AppData>(
  DataNotifier.new,
);

/// A provider that returns a single record by its ID.
///
/// The `family` modifier is used to pass the table and record IDs to the provider.
final recordByIdProvider =
    Provider.family<Map<String, dynamic>?, ({String tableId, String recordId})>(
      (ref, ids) {
        return ref
            .watch(dataProvider)
            .when(
              data: (allData) {
                final records = allData[ids.tableId] ?? [];

                try {
                  return records.firstWhere((r) => r['_id'] == ids.recordId);
                } catch (e) {
                  return null;
                }
              },
              loading: () => null,
              error: (_, _) => null,
            );
      },
    );
