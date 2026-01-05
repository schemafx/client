import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:schemafx/ui/widgets/connector_discovery_dialog.dart';

/// A utility class for showing dialogs in the editor sidebar.
class Dialogs {
  /// Shows a dialog for adding a new table.
  static Future<String?> showAddTable(BuildContext context, WidgetRef ref) =>
      showDialog<String?>(
        context: context,
        builder: (BuildContext context) => const ConnectorDiscoveryDialog(),
      );

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
  ) => showDialog<void>(
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
      width: 400,
      context: context,
      body: const FieldEditorContainer(),
    );
  }
}

class FieldEditorContainer extends ConsumerWidget {
  const FieldEditorContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(selectedEditorTableProvider);
    final field = ref.watch(selectedFieldProvider);
    final schema = ref.watch(schemaProvider).value;

    if (table == null || field == null || schema == null) {
      return const Center(child: Text('No field selected'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(title: const Text('Field Properties')),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FieldEditor(
              field: field,
              schema: schema,
              onUpdate: (updatedField) {
                ref
                    .read(schemaProvider.notifier)
                    .updateElement(updatedField, 'fields', parentId: table.id);
              },
            ),
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
    );
  }
}

class FieldEditor extends StatelessWidget {
  final AppField field;
  final AppSchema schema;
  final ValueChanged<AppField> onUpdate;
  final bool isNested;

  const FieldEditor({
    super.key,
    required this.field,
    required this.schema,
    required this.onUpdate,
    this.isNested = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: ValueKey('field_name_${field.id}'),
          initialValue: field.name,
          decoration: const InputDecoration(labelText: 'Field Name'),
          onChanged: (newName) => onUpdate(field.copyWith(name: newName)),
        ),
        CheckboxListTile(
          title: const Text('Required'),
          value: field.isRequired,
          onChanged: (newValue) {
            if (newValue == null) return;
            onUpdate(field.copyWith(isRequired: newValue));
          },
        ),
        CheckboxListTile(
          title: const Text('Key'),
          value: field.isKey,
          onChanged: (newValue) {
            if (newValue == null) return;
            onUpdate(field.copyWith(isKey: newValue));
          },
        ),
        if (field.type == AppFieldType.text || field.type == AppFieldType.json)
          CheckboxListTile(
            title: const Text('Encrypted'),
            value: field.encrypted,
            onChanged: (newValue) {
              if (newValue == null) return;
              onUpdate(field.copyWith(encrypted: newValue));
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
            onUpdate(
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
                fields: newType == AppFieldType.json ? [] : null,
                child: null,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        if (field.type == AppFieldType.reference)
          DropdownButtonFormField<String>(
            initialValue: field.referenceTo,
            decoration: const InputDecoration(labelText: 'Source Table'),
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
              onUpdate(field.copyWith(referenceTo: newRef));
            },
          ),
        if (field.type == AppFieldType.text) ...[
          TextFormField(
            initialValue: field.minLength?.toString(),
            decoration: const InputDecoration(labelText: 'Min Length'),
            onChanged: (value) =>
                onUpdate(field.copyWith(minLength: int.tryParse(value))),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: field.maxLength?.toString(),
            decoration: const InputDecoration(labelText: 'Max Length'),
            onChanged: (value) =>
                onUpdate(field.copyWith(maxLength: int.tryParse(value))),
          ),
        ],
        if (field.type == AppFieldType.number) ...[
          TextFormField(
            initialValue: field.minValue?.toString(),
            decoration: const InputDecoration(labelText: 'Min Value'),
            onChanged: (value) =>
                onUpdate(field.copyWith(minValue: double.tryParse(value))),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: field.maxValue?.toString(),
            decoration: const InputDecoration(labelText: 'Max Value'),
            onChanged: (value) =>
                onUpdate(field.copyWith(maxValue: double.tryParse(value))),
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
              onUpdate(field.copyWith(startDate: newDate));
            },
            child: const Text('Select Start Date'),
          ),
          const SizedBox(height: 16),
          Text('End Date: ${field.endDate?.toIso8601String() ?? "Not set"}'),
          ElevatedButton(
            onPressed: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: field.endDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (newDate == null) return;
              onUpdate(field.copyWith(endDate: newDate));
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
            onChanged: (value) =>
                onUpdate(field.copyWith(options: value.split(','))),
          ),
        if (field.type == AppFieldType.json) ...[
          const SizedBox(height: 16),
          Text('Nested Fields', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (field.fields != null)
            ...field.fields!.asMap().entries.map((entry) {
              final index = entry.key;
              final subField = entry.value;
              return Card(
                child: ListTile(
                  title: Text(subField.name),
                  subtitle: Text(subField.type.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showNestedEditor(
                          context,
                          subField,
                          schema,
                          (updatedSubField) {
                            final newFields = List<AppField>.from(
                              field.fields!,
                            );
                            newFields[index] = updatedSubField;
                            onUpdate(field.copyWith(fields: newFields));
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () {
                          final newFields = List<AppField>.from(field.fields!);
                          newFields.removeAt(index);
                          onUpdate(field.copyWith(fields: newFields));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Field'),
            onPressed: () {
              final newField = AppField(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: 'New Field',
                type: AppFieldType.text,
              );
              _showNestedEditor(context, newField, schema, (addedField) {
                final newFields = List<AppField>.from(field.fields ?? [])
                  ..add(addedField);
                onUpdate(field.copyWith(fields: newFields));
              }, isNew: true);
            },
          ),
        ],
        if (field.type == AppFieldType.list) ...[
          const SizedBox(height: 16),
          Text('Item Schema', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (field.child != null)
            Card(
              child: ListTile(
                title: Text(field.child!.name),
                subtitle: Text(field.child!.type.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showNestedEditor(
                        context,
                        field.child!,
                        schema,
                        (updatedChild) {
                          onUpdate(field.copyWith(child: updatedChild));
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        onUpdate(field.copyWith(child: null));
                      },
                    ),
                  ],
                ),
              ),
            )
          else
            ElevatedButton(
              child: const Text('Configure Item Schema'),
              onPressed: () {
                final newChild = AppField(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: 'Item',
                  type: AppFieldType.text,
                );
                _showNestedEditor(context, newChild, schema, (childField) {
                  onUpdate(field.copyWith(child: childField));
                }, isNew: true);
              },
            ),
        ],
      ],
    );
  }

  void _showNestedEditor(
    BuildContext context,
    AppField field,
    AppSchema schema,
    ValueChanged<AppField> onSave, {
    bool isNew = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        // Use a stateful wrapper to manage the local state of the edited field
        // until "Save" is clicked.
        AppField currentField = field;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isNew ? 'Add Nested Field' : 'Edit Nested Field'),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: FieldEditor(
                    field: currentField,
                    schema: schema,
                    onUpdate: (updated) {
                      setState(() {
                        currentField = updated;
                      });
                    },
                    isNested: true,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onSave(currentField);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
