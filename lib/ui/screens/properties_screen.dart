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
            if (schema == null) return Container();
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

                                final config = {...view.config};
                                config['fields'] = newTable.fields
                                    .map((f) => f.id)
                                    .toList();

                                ref
                                    .read(schemaProvider.notifier)
                                    .updateElement(
                                      view.copyWith(
                                        tableId: value,
                                        config: config,
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
                                      children:
                                          List<String>.from(
                                                view.config['fields'] ?? [],
                                              )
                                              .map(
                                                (fieldId) => ListTile(
                                                  key: ValueKey(fieldId),
                                                  title: Text(
                                                    table.fields
                                                        .firstWhere(
                                                          (f) =>
                                                              f.id == fieldId,
                                                        )
                                                        .name,
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.delete_outline,
                                                        ),
                                                        onPressed: () {
                                                          final config = {
                                                            ...view.config,
                                                          };

                                                          config['fields'] =
                                                              List<String>.from(
                                                                    view.config['fields'] ??
                                                                        [],
                                                                  )
                                                                  .where(
                                                                    (id) =>
                                                                        id !=
                                                                        fieldId,
                                                                  )
                                                                  .toList();

                                                          ref
                                                              .read(
                                                                schemaProvider
                                                                    .notifier,
                                                              )
                                                              .updateElement(
                                                                view.copyWith(
                                                                  config:
                                                                      config,
                                                                ),
                                                                'views',
                                                              );
                                                        },
                                                      ),
                                                      const Icon(
                                                        Icons.drag_handle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onReorder: (oldIndex, newIndex) {
                                        final fields = [
                                          ...List<String>.from(
                                            view.config['fields'] ?? [],
                                          ),
                                        ];

                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }

                                        final field = fields.removeAt(oldIndex);
                                        fields.insert(newIndex, field);

                                        final config = {...view.config};
                                        config['fields'] = fields;

                                        ref
                                            .read(schemaProvider.notifier)
                                            .updateElement(
                                              view.copyWith(config: config),
                                              'views',
                                            );
                                      },
                                    ),
                                    const Divider(),
                                    ...table.fields
                                        .where(
                                          (field) => !List<String>.from(
                                            view.config['fields'] ?? [],
                                          ).contains(field.id),
                                        )
                                        .map(
                                          (field) => CheckboxListTile(
                                            title: Text(field.name),
                                            value: false,
                                            onChanged: (value) {
                                              final config = {...view.config};
                                              config['fields'] = [
                                                ...List<String>.from(
                                                  view.config['fields'] ?? [],
                                                ),
                                                field.id,
                                              ];

                                              ref
                                                  .read(schemaProvider.notifier)
                                                  .updateElement(
                                                    view.copyWith(
                                                      config: config,
                                                    ),
                                                    'views',
                                                  );
                                            },
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
                            const SizedBox(height: 16),
                            if (view.type == AppViewType.table)
                              CheckboxListTile(
                                title: const Text('Show Empty Table'),
                                value: view.config['showEmpty'] ?? false,
                                onChanged: (value) {
                                  final config = {...view.config};
                                  config['showEmpty'] = value ?? false;

                                  ref
                                      .read(schemaProvider.notifier)
                                      .updateElement(
                                        view.copyWith(config: config),
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
