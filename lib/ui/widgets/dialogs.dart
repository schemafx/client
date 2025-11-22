import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:side_sheet/side_sheet.dart';

/// A utility class for showing dialogs in the editor sidebar.
class Dialogs {
  /// Shows a dialog for adding a new table.
  static Future<void> showAddTable(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: 'New Table');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Table'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a table name'
                  : null,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newTable = AppTable(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text,
                  );

                  await ref
                      .read(schemaProvider.notifier)
                      .addElement(newTable, 'tables');

                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog for renaming a view.
  static Future<void> showRenameView(
    BuildContext context,
    WidgetRef ref,
    AppView view,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: view.name);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Rename View'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a view name'
                : null,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Rename'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref
                    .read(schemaProvider.notifier)
                    .updateElement(
                      view.copyWith(name: controller.text),
                      'views',
                    );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for renaming a table.
  static Future<void> showRenameTable(
    BuildContext context,
    WidgetRef ref,
    AppTable table,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: table.name);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Rename Table'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please enter a table name'
                : null,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Rename'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref
                    .read(schemaProvider.notifier)
                    .updateElement(
                      table.copyWith(name: controller.text),
                      'tables',
                    );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for deleting a table.
  static Future<void> showDeleteTable(
    BuildContext context,
    WidgetRef ref,
    AppTable table,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Table'),
        content: Text('Are you sure you want to delete "${table.name}"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              await ref
                  .read(schemaProvider.notifier)
                  .deleteElement(table.id, 'tables');

              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for deleting a view.
  static Future<void> showDeleteView(
    BuildContext context,
    WidgetRef ref,
    AppView view,
  ) => showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete View'),
      content: Text('Are you sure you want to delete "${view.name}"?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () async {
            await ref
                .read(schemaProvider.notifier)
                .deleteElement(view.id, 'views');

            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  static Future<void> showEditField(BuildContext context, WidgetRef ref) async {
    final table = ref.watch(selectedEditorTableProvider);
    final field = ref.watch(selectedFieldProvider);
    final schema = ref.watch(schemaProvider).value;

    if (table == null || field == null || schema == null) return;

    return SideSheet.right(
      width: 300,
      context: context,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(title: Text('Field Properties')),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey('field_name_${field.id}'),
                  initialValue: field.name,
                  decoration: const InputDecoration(labelText: 'Field Name'),
                  onChanged: (newName) => ref
                      .read(schemaProvider.notifier)
                      .updateElement(
                        field.copyWith(name: newName),
                        'fields',
                        parentId: table.id,
                      ),
                ),
                CheckboxListTile(
                  title: const Text('Required'),
                  value: field.isRequired,
                  onChanged: (newValue) {
                    if (newValue == null) return;

                    ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(isRequired: newValue),
                          'fields',
                          parentId: table.id,
                        );
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AppFieldType>(
                  initialValue: field.type,
                  decoration: const InputDecoration(labelText: 'Field Type'),
                  items: AppFieldType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (newType) {
                    if (newType == null) return;

                    ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(
                            type: newType,
                            referenceTo: null,
                            minLength: null,
                            maxLength: null,
                            minValue: null,
                            maxValue: null,
                            startDate: null,
                            endDate: null,
                            options: null,
                          ),
                          'fields',
                          parentId: table.id,
                        );
                  },
                ),
                const SizedBox(height: 16),
                if (field.type == AppFieldType.reference)
                  DropdownButtonFormField<String>(
                    initialValue: field.referenceTo,
                    decoration: const InputDecoration(
                      labelText: 'Source Table',
                    ),
                    items: schema.tables
                        .map(
                          (table) => DropdownMenuItem(
                            value: table.id,
                            child: Text(table.name),
                          ),
                        )
                        .toList(),
                    onChanged: (newRef) {
                      if (newRef == null) return;

                      ref
                          .read(schemaProvider.notifier)
                          .updateElement(
                            field.copyWith(referenceTo: newRef),
                            'fields',
                            parentId: table.id,
                          );
                    },
                  ),
                if (field.type == AppFieldType.text) ...[
                  TextFormField(
                    initialValue: field.minLength?.toString(),
                    decoration: const InputDecoration(labelText: 'Min Length'),
                    onChanged: (value) => ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(minLength: int.tryParse(value)),
                          'fields',
                          parentId: table.id,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: field.maxLength?.toString(),
                    decoration: const InputDecoration(labelText: 'Max Length'),
                    onChanged: (value) => ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(maxLength: int.tryParse(value)),
                          'fields',
                          parentId: table.id,
                        ),
                  ),
                ],
                if (field.type == AppFieldType.number) ...[
                  TextFormField(
                    initialValue: field.minValue?.toString(),
                    decoration: const InputDecoration(labelText: 'Min Value'),
                    onChanged: (value) => ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(minValue: double.tryParse(value)),
                          'fields',
                          parentId: table.id,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: field.maxValue?.toString(),
                    decoration: const InputDecoration(labelText: 'Max Value'),
                    onChanged: (value) => ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(maxValue: double.tryParse(value)),
                          'fields',
                          parentId: table.id,
                        ),
                  ),
                ],
                if (field.type == AppFieldType.date) ...[
                  Text(
                    'Start Date: ${field.startDate?.toIso8601String() ?? "Not set"}',
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newDate = await showDatePicker(
                        context: context,
                        initialDate: field.startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (newDate == null) return;

                      ref
                          .read(schemaProvider.notifier)
                          .updateElement(
                            field.copyWith(startDate: newDate),
                            'fields',
                            parentId: table.id,
                          );
                    },
                    child: const Text('Select Start Date'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'End Date: ${field.endDate?.toIso8601String() ?? "Not set"}',
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newDate = await showDatePicker(
                        context: context,
                        initialDate: field.endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (newDate == null) return;

                      ref
                          .read(schemaProvider.notifier)
                          .updateElement(
                            field.copyWith(endDate: newDate),
                            'fields',
                            parentId: table.id,
                          );
                    },
                    child: const Text('Select End Date'),
                  ),
                ],
                if (field.type == AppFieldType.dropdown)
                  TextFormField(
                    initialValue: field.options?.join(','),
                    decoration: const InputDecoration(
                      labelText: 'Options (comma-separated)',
                    ),
                    onChanged: (value) => ref
                        .read(schemaProvider.notifier)
                        .updateElement(
                          field.copyWith(options: value.split(',')),
                          'fields',
                          parentId: table.id,
                        ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Field'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () async {
                  await ref
                      .read(schemaProvider.notifier)
                      .deleteElement(field.id, 'fields', parentId: table.id);

                  ref.read(selectedFieldProvider.notifier).select(null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
