import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/base_notifier.dart';
import 'package:schemafx/repositories/data_repository.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/services/auth_service.dart';
import 'package:schemafx/services/secure_storage_service.dart';

class SecureStorageServiceNotifier extends Notifier<SecureStorageService> {
  @override
  SecureStorageService build() => SecureStorageService();
}

final secureStorageServiceProvider =
    NotifierProvider<SecureStorageServiceNotifier, SecureStorageService>(
      SecureStorageServiceNotifier.new,
    );

/// A notifier that manages the application Id.
class AppIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setId(String? appId) {
    state = appId;
  }
}

/// A provider that exposes the current application id and allows it to be modified.
final appIdProvider = NotifierProvider<AppIdNotifier, String?>(
  AppIdNotifier.new,
);

/// A notifier that manages the entire application schema.
///
/// This notifier is responsible for loading, saving, and modifying the
/// [AppSchema] which includes all tables and fields.
class SchemaNotifier extends BaseNotifier<AppSchema?> {
  late final _repo = DataRepository(ref);
  late final _apiService = ApiService();

  @override
  Future<AppSchema?> build() async {
    final appId = ref.watch(appIdProvider);
    if (appId == null) return null;
    return _repo.loadSchema();
  }

  Future<void> addElement(dynamic element, String partOf, {String? parentId}) =>
      _updateSchema(
        _apiService.post('apps/${ref.read(appIdProvider)}/schema', {
          'action': 'add',
          'element': parentId == null
              ? {'partOf': partOf, 'element': element}
              : {'partOf': partOf, 'element': element, 'parentId': parentId},
        }),
      );

  Future<void> updateElement(
    dynamic element,
    String partOf, {
    String? parentId,
  }) => _updateSchema(
    _apiService.post('apps/${ref.read(appIdProvider)}/schema', {
      'action': 'update',
      'element': parentId == null
          ? {'partOf': partOf, 'element': element}
          : {'partOf': partOf, 'element': element, 'parentId': parentId},
    }),
  );

  Future<void> deleteElement(
    String elementId,
    String partOf, {
    String? parentId,
  }) => _updateSchema(
    _apiService.post('apps/${ref.read(appIdProvider)}/schema', {
      'action': 'delete',
      'element': parentId == null
          ? {'partOf': partOf, 'elementId': elementId}
          : {'partOf': partOf, 'elementId': elementId, 'parentId': parentId},
    }),
  );

  Future<String?> addTableFromConnector(
    String connectorName,
    List<String> path, {
    String? connectionId,
  }) async {
    final currentAppId = ref.read(appIdProvider);
    final newSchema = AppSchema.fromJson(
      await _apiService.addTable(
        connectorName,
        path,
        currentAppId,
        connectionId: connectionId,
      ),
    );

    if (currentAppId == null) {
      ref.read(appIdProvider.notifier).setId(newSchema.id);
      return newSchema.id;
    }

    await mutate(() async => newSchema, 'Table Added');
    return newSchema.id;
  }

  Future<void> reorderElement(
    int oldIndex,
    int newIndex,
    String partOf, {
    String? parentId,
  }) => _updateSchema(
    _apiService.post('apps/${ref.read(appIdProvider)}/schema', {
      'action': 'reorder',
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'element': parentId == null
          ? {'partOf': partOf}
          : {'partOf': partOf, 'parentId': parentId},
    }),
  );

  Future<void> _updateSchema(Future<dynamic> query) async {
    final newState = AppSchema.fromJson(await query);
    return mutate(() async => newState, 'Saved');
  }
}

final schemaProvider = AsyncNotifierProvider<SchemaNotifier, AppSchema?>(
  SchemaNotifier.new,
);

class SelectedTableNotifier extends Notifier<String?> {
  @override
  String? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value;
      final currentState = state;

      if (schema == null) return;

      if (currentState != null) {
        final tableExists = schema.tables.any((t) => t.id == currentState);
        if (!tableExists) state = schema.tables.firstOrNull?.id;
      } else if (schema.tables.isNotEmpty) {
        state = schema.tables.first.id;
      }
    });

    return ref.read(schemaProvider).value?.tables.firstOrNull?.id;
  }

  /// Selects the table with the given [tableId].
  void selectTable(String? tableId) {
    state = tableId;
  }
}

/// A provider that exposes the ID of the currently selected table in Runtime mode.
final selectedTableProvider = NotifierProvider<SelectedTableNotifier, String?>(
  SelectedTableNotifier.new,
);

/// A notifier that manages the currently selected view in Runtime mode.
class SelectedRuntimeViewNotifier extends Notifier<String?> {
  @override
  String? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value;
      final currentState = state;

      if (schema == null) return;

      if (currentState != null) {
        final viewExists = schema.views.any((v) => v.id == currentState);
        if (!viewExists) state = schema.views.firstOrNull?.id;
      } else if (schema.views.isNotEmpty) {
        state = schema.views.first.id;
      }
    });

    return ref.read(schemaProvider).value?.views.firstOrNull?.id;
  }

  /// Selects the view with the given [viewId].
  void selectView(String? viewId) {
    state = viewId;
  }
}

/// A provider that exposes the ID of the currently selected view in Runtime mode.
final selectedRuntimeViewProvider =
    NotifierProvider<SelectedRuntimeViewNotifier, String?>(
      SelectedRuntimeViewNotifier.new,
    );

/// A notifier that manages the currently selected table in Editor mode.
class SelectedEditorTableNotifier extends Notifier<AppTable?> {
  @override
  AppTable? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value;
      final currentTableId = state?.id;

      if (schema == null || currentTableId == null) return;

      try {
        state = schema.tables.firstWhere((t) => t.id == currentTableId);
      } catch (e) {
        state = null;
      }
    });

    return null;
  }

  /// Selects the given [table].
  void select(AppTable? table) {
    state = table;

    if (table == null) return;
    ref.read(selectedEditorViewProvider.notifier).select(null);
  }
}

/// A provider that exposes the currently selected [AppTable] in Editor mode.
final selectedEditorTableProvider =
    NotifierProvider<SelectedEditorTableNotifier, AppTable?>(
      SelectedEditorTableNotifier.new,
    );

/// A notifier that manages the currently selected view in Editor mode.
class SelectedEditorViewNotifier extends Notifier<AppView?> {
  @override
  AppView? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value;
      final currentViewId = state?.id;

      if (schema == null || currentViewId == null) return;

      try {
        state = schema.views.firstWhere((v) => v.id == currentViewId);
      } catch (e) {
        state = null;
      }
    });

    return null;
  }

  /// Selects the given [view].
  void select(AppView? view) {
    state = view;

    if (view == null) return;
    ref.read(selectedEditorTableProvider.notifier).select(null);
  }
}

/// A provider that exposes the currently selected [AppView] in Editor mode.
final selectedEditorViewProvider =
    NotifierProvider<SelectedEditorViewNotifier, AppView?>(
      SelectedEditorViewNotifier.new,
    );

/// A notifier that manages the currently selected field in the Table Editor.
class SelectedFieldNotifier extends Notifier<AppField?> {
  @override
  AppField? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value;
      final currentFieldId = state?.id;
      final currentTable = ref.read(selectedEditorTableProvider);

      if (schema == null || currentFieldId == null || currentTable == null) {
        return;
      }

      try {
        state = schema.tables
            .firstWhere((t) => t.id == currentTable.id)
            .fields
            .firstWhere((f) => f.id == currentFieldId);
      } catch (e) {
        state = null;
      }
    });

    return null;
  }

  /// Selects the given [field].
  void select(AppField? field) {
    state = field;
  }
}

/// A provider that exposes the currently selected [AppField] in the Table Editor.
final selectedFieldProvider =
    NotifierProvider<SelectedFieldNotifier, AppField?>(
      SelectedFieldNotifier.new,
    );

/// A notifier to manage the auth completer for mobile deep linking.
class AuthCompleterNotifier extends Notifier<Completer<AuthResult>?> {
  @override
  Completer<AuthResult>? build() => null;

  void set(Completer<AuthResult> completer) {
    state = completer;
  }

  void clear() {
    state = null;
  }
}

/// A provider used to complete the authentication flow when the app is
/// resumed from a deep link on mobile.
final authCompleterProvider =
    NotifierProvider<AuthCompleterNotifier, Completer<AuthResult>?>(
      AuthCompleterNotifier.new,
    );
