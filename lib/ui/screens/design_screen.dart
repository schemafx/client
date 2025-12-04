import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/screens/data_screen.dart';
import 'package:schemafx/ui/widgets/dialogs.dart';

class DesignScreen extends ConsumerWidget {
  const DesignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = ref.watch(schemaProvider).value;
    if (schema == null) return Container();
    final searchQuery = ref.watch(designPagesSearchQueryProvider).toLowerCase();
    final selectedView = ref.watch(selectedEditorViewProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: const Icon(Icons.design_services_outlined, size: 28),
          title: const Text('Design'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New Page',
              onPressed: () => _showAddViewDialog(context, ref),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.control_point_duplicate_outlined,
                size: 28,
              ),
              tooltip: 'New Source',
              onPressed: () => showDialog(
                context: context,
                builder: (context) => DataScreen(),
                fullscreenDialog: true,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputChip(
                    label: const Text('Pages'),
                    avatar: const Icon(Icons.splitscreen_outlined),
                    selected: true,
                    onSelected: (_) => Null,
                    showCheckmark: false,
                  ),
                  InputChip(
                    label: const Text('Data'),
                    avatar: const Icon(Icons.layers_outlined),
                    selected: false,
                    onSelected: (value) => {
                      value
                          ? showDialog(
                              context: context,
                              builder: (context) => DataScreen(),
                              fullscreenDialog: true,
                            )
                          : Null,
                    },
                    showCheckmark: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SearchBar(
                elevation: WidgetStateProperty.all(0.0),
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search_outlined),
                ),
                hintText: 'Search Pages',
                onChanged: (value) => ref
                    .read(designPagesSearchQueryProvider.notifier)
                    .setQuery(value),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ReorderableListView(
                  shrinkWrap: true,
                  children: schema.views
                      .where(
                        (view) => view.name.toLowerCase().contains(searchQuery),
                      )
                      .map(
                        (view) => ListTile(
                          style: ListTileStyle.list,
                          key: ValueKey(view.id),
                          leading: const Icon(
                            Icons.view_quilt_outlined,
                            size: 16,
                          ),
                          selected: view.id == selectedView?.id,
                          title: Text(view.name),
                          subtitle: Text(view.type.name),
                          dense: true,
                          onTap: () {
                            ref
                                .read(selectedEditorTableProvider.notifier)
                                .select(null);
                            ref
                                .read(selectedEditorViewProvider.notifier)
                                .select(view);
                          },
                          onLongPress: () =>
                              showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                  Offset.zero & const Size(40, 40),
                                  Offset.zero &
                                      (Overlay.of(
                                                context,
                                              ).context.findRenderObject()
                                              as RenderBox)
                                          .size,
                                ),
                                items: [
                                  const PopupMenuItem(
                                    value: 'rename',
                                    child: Text('Rename'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ).then((value) {
                                if (!context.mounted) return;

                                if (value == 'rename') {
                                  Dialogs.showRenameView(context, ref, view);
                                } else if (value == 'delete') {
                                  Dialogs.showDeleteView(context, ref, view);
                                }
                              }),
                        ),
                      )
                      .toList(),
                  onReorder: (oldIndex, newIndex) => ref
                      .read(schemaProvider.notifier)
                      .reorderElement(oldIndex, newIndex, 'views'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddViewDialog(BuildContext context, WidgetRef ref) async {
    final schema = ref.read(schemaProvider).value;

    if (schema == null || schema.tables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a table before creating a view.'),
        ),
      );

      return;
    }

    final defaultTable = schema.tables.first;
    await ref
        .read(schemaProvider.notifier)
        .addElement(
          AppView(
            id: 'view_${DateTime.now().millisecondsSinceEpoch}',
            name: 'New View',
            tableId: defaultTable.id,
            type: AppViewType.table,
            config: {'fields': defaultTable.fields.map((f) => f.id).toList()},
          ),
          'views',
        );
  }
}
