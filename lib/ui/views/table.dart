import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

class XTableView extends ConsumerWidget {
  final AppTable table;
  final AppView view;

  const XTableView({super.key, required this.table, required this.view});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(tableDataProvider(table.id));

    return asyncData.when(
      loading: () => _buildSkeleton(context),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (records) {
        if (records.isEmpty && !(view.config['showEmpty'] as bool? ?? false)) {
          return const Center(child: Text('No records found.'));
        }

        final visibleFields = List<String>.from(
          view.config['fields'] ?? [],
        ).map((id) => table.fields.firstWhere((f) => f.id == id));

        final tableWidget = SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: visibleFields
                .map((field) => DataColumn(label: Text(field.name)))
                .toList(),
            rows: records
                .map(
                  (record) => DataRow(
                    cells: visibleFields
                        .map(
                          (field) => DataCell(
                            _CellWidget(
                              table: table,
                              record: record,
                              field: field,
                              onTap: () => _showEditDialog(
                                context,
                                ref,
                                table,
                                record,
                                field,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        );

        if (records.isEmpty && (view.config['showEmpty'] as bool? ?? false)) {
          return Column(
            children: [
              tableWidget,
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No records found.'),
              ),
            ],
          );
        }

        return tableWidget;
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    // Generate dummy columns and rows for skeleton
    final visibleFields = List<String>.from(
      view.config['fields'] ?? [],
    ).map((id) => table.fields.firstWhere((f) => f.id == id)).toList();

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: visibleFields
            .map((field) => DataColumn(label: Text(field.name)))
            .toList(),
        rows: List.generate(
          5,
          (index) => DataRow(
            cells: visibleFields
                .map(
                  (field) => DataCell(
                    Container(
                      width: 100,
                      height: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
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

              ref.read(tableActionControllerProvider).executeAction(
                table.id,
                table.actions
                    .firstWhere((action) => action.type == AppActionType.update)
                    .id,
                [newRecord],
              );

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _CellWidget extends ConsumerWidget {
  final AppTable table;
  final Map<String, dynamic> record;
  final AppField field;
  final VoidCallback onTap;

  const _CellWidget({
    required this.table,
    required this.record,
    required this.field,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = record[field.id];
    String displayValue = value?.toString() ?? '';

    if ((field.type == AppFieldType.reference) && value != null) {
      final relatedRecord = ref.watch(
        recordByIdProvider((tableId: field.referenceTo!, recordId: value)),
      );

      final asyncSchema = ref.watch(schemaProvider);
      displayValue = asyncSchema.when(
        data: (schema) {
          if (schema == null) return '';
          final relatedTable = schema.getTable(field.referenceTo!);

          final displayField = relatedTable?.fields.firstWhere(
            (f) => f.type == AppFieldType.text || f.type == AppFieldType.email,
            orElse: () => relatedTable.fields.first,
          );

          return '🔗 ${relatedRecord?[displayField?.id ?? '_id'] ?? '...'}';
        },
        error: (e, st) => 'Error',
        loading: () => '...',
      );
    }

    return InkWell(onTap: onTap, child: Text(displayValue));
  }
}
