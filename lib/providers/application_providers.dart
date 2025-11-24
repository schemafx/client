import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/base_notifier.dart';
import 'package:schemafx/repositories/data_repository.dart';
import 'package:schemafx/models/models.dart';
import 'mock_data.dart';

/// Defines the current mode of the application.
enum AppMode {
  /// The user is editing the application schema.
  editor,

  /// The user is interacting with the application's data.
  runtime,
}

/// A notifier that manages the entire application schema.
///
/// This notifier is responsible for loading, saving, and modifying the
/// [AppSchema] which includes all tables and fields.
class SchemaNotifier extends BaseNotifier<AppSchema> {
  late final _repo = DataRepository(ref);

  @override
  Future<AppSchema> build() async {
    final schema = await _repo.loadSchema();

    if (schema != null) return schema;

    await _repo.saveSchema(demoSchema);
    return demoSchema;
  }

  Future<void> addElement(
    dynamic element,
    String partOf, {
    String? parentId,
  }) async {
    final oldState = await future;
    late AppSchema newState;

    if (partOf == 'tables') {
      newState = oldState.copyWith(tables: [...oldState.tables, element]);
    } else if (partOf == 'views') {
      newState = oldState.copyWith(views: [...oldState.views, element]);
    } else if (partOf == 'fields' && parentId != null) {
      final oldFieldsLength = oldState.tables
          .firstWhere((table) => table.id == parentId)
          .fields
          .length;

      newState = oldState.copyWith(
        tables: oldState.tables
            .map(
              (table) => table.id == parentId
                  ? table.copyWith(fields: [...table.fields, element])
                  : table,
            )
            .toList(),
        views: oldState.views
            .map(
              (view) =>
                  view.tableId == parentId &&
                      view.fields.length == oldFieldsLength
                  ? view.copyWith(
                      fields: [...view.fields, (element as AppField).id],
                    )
                  : view,
            )
            .toList(),
      );
    } else {
      return;
    }

    return mutate(() async {
      await _repo.saveSchema(newState);
      return newState;
    }, 'Added successfully');
  }

  Future<void> updateElement(
    dynamic element,
    String partOf, {
    String? parentId,
  }) async {
    final oldState = await future;
    late AppSchema newState;

    if (partOf == 'tables') {
      newState = oldState.copyWith(
        tables: oldState.tables
            .map((t) => t.id == element.id ? element as AppTable : t)
            .toList(),
      );
    } else if (partOf == 'views') {
      newState = oldState.copyWith(
        views: oldState.views
            .map((t) => t.id == element.id ? element as AppView : t)
            .toList(),
      );
    } else if (partOf == 'fields' && parentId != null) {
      newState = oldState.copyWith(
        tables: oldState.tables
            .map(
              (table) => table.id == parentId
                  ? table.copyWith(
                      fields: table.fields
                          .map(
                            (f) => f.id == element.id ? element as AppField : f,
                          )
                          .toList(),
                    )
                  : table,
            )
            .toList(),
      );
    } else {
      return;
    }

    return mutate(() async {
      await _repo.saveSchema(newState);
      return newState;
    }, 'Updated successfully');
  }

  Future<void> deleteElement(
    String elementId,
    String partOf, {
    String? parentId,
  }) async {
    final oldState = await future;
    late AppSchema newState;

    if (partOf == 'tables') {
      newState = oldState.copyWith(
        tables: oldState.tables.where((t) => t.id != elementId).toList(),
      );
    } else if (partOf == 'views') {
      newState = oldState.copyWith(
        views: oldState.views.where((t) => t.id != elementId).toList(),
      );
    } else if (partOf == 'fields' && parentId != null) {
      newState = oldState.copyWith(
        tables: oldState.tables
            .map(
              (table) => table.id == parentId
                  ? table.copyWith(
                      fields: table.fields
                          .where((f) => f.id != elementId)
                          .toList(),
                    )
                  : table,
            )
            .toList(),
        views: oldState.views
            .map(
              (view) => view.tableId == parentId
                  ? view.copyWith(
                      fields: view.fields
                          .where((field) => field != elementId)
                          .toList(),
                    )
                  : view,
            )
            .toList(),
      );
    } else {
      return;
    }

    return mutate(() async {
      await _repo.saveSchema(newState);
      return newState;
    }, 'Deleted successfully');
  }

  Future<void> reorderElement(
    int oldIndex,
    int newIndex,
    String partOf, {
    String? parentId,
  }) async {
    final oldState = await future;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    late List<dynamic> elements;

    if (partOf == 'tables') {
      elements = [...oldState.tables];
    } else if (partOf == 'views') {
      elements = [...oldState.views];
    } else if (partOf == 'fields' && parentId != null) {
      final table = oldState.tables.firstWhere((table) => table.id == parentId);
      final fields = [...table.fields];

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final field = fields.removeAt(oldIndex);
      fields.insert(newIndex, field);

      return updateElement(table.copyWith(fields: fields), 'tables');
    } else {
      return;
    }

    final element = elements.removeAt(oldIndex);
    elements.insert(newIndex, element);

    late AppSchema newState;
    if (partOf == 'tables') {
      newState = oldState.copyWith(tables: List<AppTable>.from(elements));
    } else if (partOf == 'views') {
      newState = oldState.copyWith(views: List<AppView>.from(elements));
    }

    return mutate(() async {
      await _repo.saveSchema(newState);
      return newState;
    }, 'Reordered successfully');
  }
}

final schemaProvider = AsyncNotifierProvider<SchemaNotifier, AppSchema>(
  SchemaNotifier.new,
);

class SelectedTableNotifier extends Notifier<String?> {
  @override
  String? build() {
    ref.listen(schemaProvider, (previous, next) {
      if (!next.hasValue) return;

      final schema = next.value!;
      final currentState = state;

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

      final schema = next.value!;
      final currentState = state;

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

      final schema = next.value!;
      final currentTableId = state?.id;

      if (currentTableId == null) return;

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

      final schema = next.value!;
      final currentViewId = state?.id;

      if (currentViewId == null) return;

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

      final schema = next.value!;
      final currentFieldId = state?.id;
      final currentTable = ref.read(selectedEditorTableProvider);

      if (currentFieldId == null || currentTable == null) return;

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
