import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

class XFormView extends ConsumerStatefulWidget {
  final AppTable table;
  final AppView view;

  const XFormView({super.key, required this.table, required this.view});

  @override
  XFormViewState createState() => XFormViewState();
}

/// The state for the [XFormView].
class XFormViewState extends ConsumerState<XFormView> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  late Map<String, TextEditingController> _controllers;
  late Map<String, String?> _referenceValues;
  late Map<String, bool> _booleanValues;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant XFormView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.table.id != widget.table.id) _initControllers();
  }

  void _initControllers() {
    _controllers = {
      for (var field in widget.table.fields.where(
        (f) => f.type != AppFieldType.reference,
      ))
        field.id: TextEditingController(),
    };

    _referenceValues = {
      for (var field in widget.table.fields.where(
        (f) => f.type == AppFieldType.reference,
      ))
        field.id: null,
    };

    _booleanValues = {
      for (var field in widget.table.fields.where(
        (f) => f.type == AppFieldType.boolean,
      ))
        field.id: false,
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  /// Handles the form submission.
  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newRecord = <String, dynamic>{
        '_id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      _controllers.forEach(
        (fieldId, controller) => newRecord[fieldId] = controller.text,
      );

      _referenceValues.forEach((fieldId, value) => newRecord[fieldId] = value);
      _booleanValues.forEach((fieldId, value) => newRecord[fieldId] = value);

      await ref.read(dataProvider.notifier).addRow(widget.table.id, newRecord);

      for (var c in _controllers.values) {
        c.clear();
      }

      setState(() {
        _referenceValues = Map.from(_referenceValues)
          ..updateAll((key, value) => null);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      onChanged: () => setState(
        () => _isFormValid = _formKey.currentState?.validate() ?? false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.view.fields
              .map(
                (fieldId) =>
                    widget.table.fields.firstWhere((f) => f.id == fieldId),
              )
              .map((field) {
                switch (field.type) {
                  case AppFieldType.reference:
                    return _buildReferenceDropdown(field);
                  case AppFieldType.date:
                    return _buildDatePicker(field);
                  case AppFieldType.dropdown:
                    return _buildDropdownField(field);
                  case AppFieldType.boolean:
                    return _buildBooleanField(field);
                  default:
                    return _buildTextField(field);
                }
              }),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: _isFormValid ? _handleSubmit : null,
                child: const Text('Create Record'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Builds a text field for a generic field.
  Widget _buildTextField(AppField field, {bool readOnly = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      controller: _controllers[field.id],
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: field.name,
        border: const OutlineInputBorder(),
      ),
      validator: field.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );

  /// Builds a dropdown for a dropdown field.
  Widget _buildDropdownField(AppField field) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: field.name,
        border: const OutlineInputBorder(),
      ),
      items: field.options
          ?.map(
            (option) => DropdownMenuItem(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: (String? newValue) =>
          _controllers[field.id]?.text = newValue ?? '',
      validator: field.validate,
    ),
  );

  /// Builds a checkbox for a boolean field.
  Widget _buildBooleanField(AppField field) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: CheckboxListTile(
      title: Text(field.name),
      value: _booleanValues[field.id],
      onChanged: (newValue) =>
          setState(() => _booleanValues[field.id] = newValue ?? false),
    ),
  );

  /// Builds a date picker for a date field.
  Widget _buildDatePicker(AppField field) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      controller: _controllers[field.id],
      readOnly: true,
      decoration: InputDecoration(
        labelText: field.name,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: field.startDate ?? DateTime(2000),
          lastDate: field.endDate ?? DateTime(2101),
        );

        if (selectedDate != null) {
          setState(
            () => _controllers[field.id]?.text = selectedDate
                .toIso8601String()
                .substring(0, 10),
          );
        }
      },
      validator: field.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );

  /// Builds a dropdown for a reference field.
  Widget _buildReferenceDropdown(AppField field) {
    final relatedTableId = field.referenceTo;
    if (relatedTableId == null) return const SizedBox.shrink();

    // Get the records from the related table to populate the dropdown
    final asyncData = ref.watch(dataProvider);
    final asyncSchema = ref.watch(schemaProvider);

    return asyncSchema.when(
      data: (schema) {
        final relatedTable = schema.getTable(relatedTableId);
        final displayField = relatedTable?.fields.firstWhere(
          (f) => f.type == AppFieldType.text || f.type == AppFieldType.email,
          orElse: () => relatedTable.fields.first,
        );

        return asyncData.when(
          data: (allData) {
            final relatedRecords = allData[relatedTableId] ?? [];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DropdownButtonFormField<String>(
                initialValue: _referenceValues[field.id],
                decoration: InputDecoration(
                  labelText: field.name,
                  border: const OutlineInputBorder(),
                ),
                items: relatedRecords
                    .map(
                      (record) => DropdownMenuItem(
                        value: record['_id'] as String,
                        child: Text(
                          record[displayField?.id ?? '_id']?.toString() ??
                              'Untitled',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() => _referenceValues[field.id] = newValue);
                },
                validator: field.validate,
              ),
            );
          },
          error: (error, stack) =>
              const Center(child: Text('Error loading data')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) =>
          const Center(child: Text('Error loading schema')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
