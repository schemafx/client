import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/views/form.dart';
import 'package:schemafx/ui/views/table.dart';
import 'package:schemafx/ui/widgets/dialogs.dart';
import 'package:side_sheet/side_sheet.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: const Text('Data'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1),
          ),
        ),
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _DataScreenSource(),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: _DataScreenTable()),
          ],
        ),
      ),
    );
  }
}

class _DataScreenSource extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = ref.watch(schemaProvider).value;
    if (schema == null) return Container();

    final colorScheme = Theme.of(context).colorScheme;
    final searchQuery = ref.watch(dataSearchQueryProvider).toLowerCase();
    final selectedTable = ref.watch(selectedEditorTableProvider)?.id;

    final tablesList = schema.tables
        .where((table) => table.name.toLowerCase().contains(searchQuery))
        .toList();

    /// Sort Alphabetically
    tablesList.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return Column(
      children: [
        AppBar(
          leading: const Icon(Icons.dns_outlined),
          title: const Text('Sources'),
          actions: [
            IconButton(
              onPressed: () => Dialogs.showAddTable(context, ref),
              tooltip: 'New Source',
              icon: const Icon(Icons.control_point_duplicate_outlined),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SearchBar(
          hintText: 'Search Sources',
          backgroundColor: WidgetStateProperty.all(
            colorScheme.surfaceContainerHighest,
          ),
          onChanged: (value) =>
              ref.read(dataSearchQueryProvider.notifier).setQuery(value),
          elevation: WidgetStateProperty.all(0),
          trailing: const [Icon(Icons.search), SizedBox(width: 8)],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: tablesList
                .map(
                  (table) => ListTile(
                    key: ValueKey(table.id),
                    title: Text(table.name),
                    selected: selectedTable == table.id,
                    onTap: () => ref
                        .read(selectedEditorTableProvider.notifier)
                        .select(table),
                    onLongPress: () =>
                        showMenu(
                          context: context,
                          position: RelativeRect.fromRect(
                            Offset.zero & const Size(40, 40),
                            Offset.zero &
                                (Overlay.of(context).context.findRenderObject()
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
                            Dialogs.showRenameTable(context, ref, table);
                          } else if (value == 'delete') {
                            Dialogs.showDeleteTable(context, ref, table);
                          }
                        }),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DataScreenTable extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTable = ref.watch(selectedEditorTableProvider);
    if (selectedTable == null) return Container();

    return Column(
      children: [
        AppBar(
          leading: const Icon(Icons.table_chart_outlined),
          title: Text(selectedTable.name),
          actions: [
            IconButton(
              onPressed: () async {
                final field = AppField(
                  id: 'new_field_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'New Field',
                  type: AppFieldType.text,
                );

                await ref
                    .read(schemaProvider.notifier)
                    .addElement(field, 'fields', parentId: selectedTable.id);

                if (!context.mounted) return;

                ref.read(selectedFieldProvider.notifier).select(field);
                Dialogs.showEditField(context, ref);
              },
              tooltip: 'Create Column',
              icon: const Icon(Icons.add_outlined),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => SideSheet.right(
                width: 300,
                context: context,
                body: Column(
                  children: [
                    AppBar(title: Text('New Row')),
                    XFormView(
                      table: selectedTable,
                      view: AppView(
                        id: '',
                        name: '',
                        tableId: selectedTable.id,
                        type: AppViewType.form,
                        fields: selectedTable.fields
                            .map((field) => field.id)
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              tooltip: 'Add Row',
              icon: const Icon(Icons.playlist_add_outlined),
            ),
            const SizedBox(width: 4),
          ],
        ),
        Expanded(
          child: XTableView(
            table: selectedTable,
            view: AppView(
              id: '',
              name: '',
              tableId: selectedTable.id,
              type: AppViewType.table,
              fields: selectedTable.fields.map((field) => field.id).toList(),
            ),
            records: [],
          ),
        ),
      ],
    );
  }
}
