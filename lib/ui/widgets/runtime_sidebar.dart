import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/providers.dart';

/// The sidebar for the runtime mode.
///
/// This widget displays a list of all views in the current schema. Tapping on
/// a view selects it for viewing in the main content area.
class RuntimeSidebar extends ConsumerWidget {
  /// Creates a new [RuntimeSidebar].
  const RuntimeSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedViewId = ref.watch(selectedRuntimeViewProvider);

    return ref
        .watch(schemaProvider)
        .when(
          data: (schema) {
            if (schema == null) return Container();
            final selectedIndex = schema.views.indexWhere(
              (view) => view.id == selectedViewId,
            );

            return NavigationRail(
              labelType: NavigationRailLabelType.all,
              destinations: schema.views
                  .map(
                    (view) => NavigationRailDestination(
                      icon: const Icon(Icons.view_quilt_outlined),
                      label: Text(view.name),
                    ),
                  )
                  .toList(),
              onDestinationSelected: (value) => ref
                  .read(selectedRuntimeViewProvider.notifier)
                  .selectView(schema.views[value].id),
              selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
