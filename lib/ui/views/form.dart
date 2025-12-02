import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/widgets/smart_field.dart';

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
  
  // Unified storage for all field values
  late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _initFormValues();
  }

  @override
  void didUpdateWidget(covariant XFormView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.table.id != widget.table.id) _initFormValues();
  }

  void _initFormValues() {
    _formValues = {};
    // Initialize specific defaults if necessary (e.g. booleans to false)
    // Most fields start as null (missing from map) or can be pre-populated here.
    for (var field in widget.table.fields) {
      if (field.type == AppFieldType.boolean) {
        _formValues[field.id] = false;
      } else {
        _formValues[field.id] = null;
      }
    }
  }

  /// Handles the form submission.
  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Ensure all values are saved/updated

      final newRecord = <String, dynamic>{
        ..._formValues,
        '_id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // Filter out nulls if necessary, or keep them to represent explicit clearing
      // In this case, we send what we have.

      await ref.read(dataProvider.notifier).addRow(widget.table.id, newRecord);

      // Reset form
      _formKey.currentState?.reset();
      setState(() {
        _initFormValues();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.view.fields
              .map(
                (fieldId) =>
                    widget.table.fields.firstWhere((f) => f.id == fieldId),
              )
              .map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: SmartField(
                    field: field,
                    initialValue: _formValues[field.id],
                    onChanged: (newValue) {
                      _formValues[field.id] = newValue;
                    },
                  ),
                );
              }),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: _handleSubmit,
                child: const Text('Create Record'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
