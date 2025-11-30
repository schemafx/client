import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

class XTableView extends ConsumerWidget {
  final AppTable table;
  final AppView view;
  final List<Map<String, dynamic>> records;

  const XTableView({
    super.key,
    required this.table,
    required this.view,
    required this.records,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (records.isEmpty) return const Center(child: Text('No records found.'));

    final visibleFields = view.fields.map(
      (id) => table.fields.firstWhere((f) => f.id == id),
    );

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: visibleFields
            .map((field) => DataColumn(label: Text(field.name)))
            .toList(),
        rows: records
            .map(
              (record) => DataRow(
                cells: visibleFields.map((field) {
                  final value = record[field.id];
                  String displayValue = value?.toString() ?? '';

                  if ((field.type == AppFieldType.reference) && value != null) {
                    final relatedRecord = ref.watch(
                      recordByIdProvider((
                        tableId: field.referenceTo!,
                        recordId: value,
                      )),
                    );

                    final asyncSchema = ref.watch(schemaProvider);
                    displayValue = asyncSchema.when(
                      data: (schema) {
                        final relatedTable = schema.getTable(
                          field.referenceTo!,
                        );

                        final displayField = relatedTable?.fields.firstWhere(
                          (f) =>
                              f.type == AppFieldType.text ||
                              f.type == AppFieldType.email,
                          orElse: () => relatedTable.fields.first,
                        );

                        return '🔗 ${relatedRecord?[displayField?.id ?? '_id'] ?? '...'}';
                      },
                      error: (e, st) => 'Error',
                      loading: () => '...',
                    );
                  }

                  return DataCell(
                    InkWell(
                      onTap: () =>
                          _showEditDialog(context, ref, table, record, field),
                      child: Text(displayValue),
                    ),
                  );
                }).toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AppTable table,
    Map<String, dynamic> record,
    AppField field,
  ) {
    final controller = TextEditingController(
      text: record[field.id]?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${field.name}'),
        content: TextFormField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRecord = {...record};
              newRecord[field.id] = controller.text;
              final rowIndex = records.indexOf(record);

              ref
                  .read(dataProvider.notifier)
                  .updateRow(table.id, rowIndex, newRecord);

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
