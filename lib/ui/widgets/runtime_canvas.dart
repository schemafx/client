import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/app_view.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/views/form.dart';
import 'package:schemafx/ui/views/table.dart';

/// The main content area of the runtime mode.
///
/// This widget is responsible for displaying the currently selected view,
/// which can be either a [XFormView] or a [XTableView].
class RuntimeCanvas extends ConsumerWidget {
  /// Creates a new [RuntimeCanvas].
  const RuntimeCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedViewId = ref.watch(selectedRuntimeViewProvider);
    if (selectedViewId == null) {
      return const Center(child: Text('Select a view to begin.'));
    }

    return ref
        .watch(schemaProvider)
        .when(
          data: (schema) {
            if (schema == null) return Container();

            final view = schema.views.firstWhere((v) => v.id == selectedViewId);
            final table = schema.getTable(view.tableId);

            if (table == null) {
              return const Center(child: Text('Table not found.'));
            }

            late Widget viewWidget;

            switch (view.type) {
              case AppViewType.form:
                viewWidget = XFormView(table: table, view: view);
                break;
              case AppViewType.table:
                viewWidget = XTableView(table: table, view: view);

                break;
              // ignore: unreachable_switch_default
              default:
                viewWidget = Container();
                break;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: viewWidget,
            );
          },
          error: (error, stackTrace) =>
              Center(child: Text('Error loading schema: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
