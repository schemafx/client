import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

class PropertiesScreen extends ConsumerWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(selectedEditorViewProvider);
    if (view == null) return Container();

    return ref
        .watch(schemaProvider)
        .when(
          data: (schema) {
            final table = schema.getTable(view.tableId);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    leading: const Icon(Icons.build_outlined),
                    title: const Text('Properties'),
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: "Data"),
                        Tab(text: "Settings"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // Data
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: view.tableId,
                              decoration: const InputDecoration(
                                labelText: 'Table',
                                border: OutlineInputBorder(),
                              ),
                              items: schema.tables
                                  .map(
                                    (table) => DropdownMenuItem(
                                      value: table.id,
                                      child: Text(table.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                final newTable = schema.tables.firstWhere(
                                  (t) => t.id == value,
                                );
                                final allFieldIds = newTable.fields
                                    .map((f) => f.id)
                                    .toList();

                                ref
                                    .read(schemaProvider.notifier)
                                    .updateElement(
                                      view.copyWith(
                                        tableId: value,
                                        fields: allFieldIds,
                                      ),
                                      'views',
                                    );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Field Selector
                            if (table != null)
                              Card(
                                child: Column(
                                  children: [
                                    const ListTile(
                                      title: Text('Visible Fields'),
                                    ),
                                    const Divider(),
                                    ReorderableListView(
                                      shrinkWrap: true,
                                      children: view.fields
                                          .map(
                                            (fieldId) => ListTile(
                                              key: ValueKey(fieldId),
                                              title: Text(
                                                table.fields
                                                    .firstWhere(
                                                      (f) => f.id == fieldId,
                                                    )
                                                    .name,
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                    ),
                                                    onPressed: () => ref
                                                        .read(
                                                          schemaProvider
                                                              .notifier,
                                                        )
                                                        .updateElement(
                                                          view.copyWith(
                                                            fields: view.fields
                                                                .where(
                                                                  (id) =>
                                                                      id !=
                                                                      fieldId,
                                                                )
                                                                .toList(),
                                                          ),
                                                          'views',
                                                        ),
                                                  ),
                                                  const Icon(Icons.drag_handle),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onReorder: (oldIndex, newIndex) {
                                        final fields = [...view.fields];
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }

                                        final field = fields.removeAt(oldIndex);
                                        fields.insert(newIndex, field);

                                        ref
                                            .read(schemaProvider.notifier)
                                            .updateElement(
                                              view.copyWith(fields: fields),
                                              'views',
                                            );
                                      },
                                    ),
                                    const Divider(),
                                    ...table.fields
                                        .where(
                                          (field) =>
                                              !view.fields.contains(field.id),
                                        )
                                        .map(
                                          (field) => CheckboxListTile(
                                            title: Text(field.name),
                                            value: false,
                                            onChanged: (value) => ref
                                                .read(schemaProvider.notifier)
                                                .updateElement(
                                                  view.copyWith(
                                                    fields: [
                                                      ...view.fields,
                                                      field.id,
                                                    ],
                                                  ),
                                                  'views',
                                                ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Settings
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            TextFormField(
                              initialValue: view.name,
                              decoration: const InputDecoration(
                                labelText: 'View Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => ref
                                  .read(schemaProvider.notifier)
                                  .updateElement(
                                    view.copyWith(name: value),
                                    'views',
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // View Type Selector
                            DropdownButtonFormField<AppViewType>(
                              initialValue: view.type,
                              decoration: const InputDecoration(
                                labelText: 'View Type',
                                border: OutlineInputBorder(),
                              ),
                              items: AppViewType.values
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                ref
                                    .read(schemaProvider.notifier)
                                    .updateElement(
                                      view.copyWith(type: value),
                                      'views',
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Container(),
          loading: () => Container(),
        );
  }
}
