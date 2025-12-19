import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/application_providers.dart';
import 'package:schemafx/providers/ui_providers.dart';
import 'package:schemafx/repositories/data_repository.dart';
import 'package:schemafx/services/api_service.dart';

/// A type definition for the application's data.
///
/// It's a map where the key is the table ID and the value is a list of rows.
/// Each row is a map where the key is the field ID and the value is the cell content.
typedef AppData = Map<String, List<Map<String, dynamic>>>;

/// A provider that returns a list of records for a specific table.
/// It uses autoDispose to ensure data is fresh when the view is revisited.
final tableDataProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tableId) async {
      final repo = DataRepository(ref);
      return await repo.loadTableData(tableId);
    });

/// A controller for executing actions on a table.
class TableActionController {
  final Ref ref;
  TableActionController(this.ref);
  late final _apiService = ApiService();

  Future<void> executeAction(
    String tableId,
    String actionId,
    List<Map<String, dynamic>> rows, {
    Map<String, dynamic>? payload,
  }) async {
    final scaffoldMessenger = ref.read(scaffoldMessengerKeyProvider);

    try {
      scaffoldMessenger.currentState?.showSnackBar(
        const SnackBar(content: Text('Saving...')),
      );

      await _apiService.post('apps/${ref.read(appIdProvider)}/data/$tableId', {
        'actionId': actionId,
        'rows': rows,
        'payload': payload,
      });

      // Invalidate the provider to force a refresh
      ref.invalidate(tableDataProvider(tableId));

      scaffoldMessenger.currentState?.hideCurrentSnackBar();
      scaffoldMessenger.currentState?.showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    } catch (e) {
      scaffoldMessenger.currentState?.hideCurrentSnackBar();
      scaffoldMessenger.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(
            scaffoldMessenger.currentContext!,
          ).colorScheme.error,
          content: Text('Error: ${e.toString()}'),
        ),
      );
      rethrow;
    }
  }
}

final tableActionControllerProvider = Provider(
  (ref) => TableActionController(ref),
);

/// A provider that returns a single record by its ID.
///
/// The `family` modifier is used to pass the table and record IDs to the provider.
final recordByIdProvider = Provider.autoDispose
    .family<Map<String, dynamic>?, ({String tableId, String recordId})>(
      (ref, ids) => ref
          .watch(tableDataProvider(ids.tableId))
          .when(
            data: (records) {
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
