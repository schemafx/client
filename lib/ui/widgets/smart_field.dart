import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

/// A smart field that renders the appropriate input widget based on the field type.
/// It handles recursive structures for JSON and List fields.
class SmartField extends ConsumerStatefulWidget {
  final AppField field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final bool readOnly;

  const SmartField({
    super.key,
    required this.field,
    required this.onChanged,
    this.initialValue,
    this.readOnly = false,
  });

  @override
  ConsumerState<SmartField> createState() => _SmartFieldState();
}

class _SmartFieldState extends ConsumerState<SmartField> {
  late TextEditingController _textController;
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  dynamic _lastSeenValue;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _lastSeenValue = widget.initialValue;
    if (widget.initialValue != null &&
        (widget.field.type == AppFieldType.text ||
            widget.field.type == AppFieldType.number ||
            widget.field.type == AppFieldType.email ||
            widget.field.type == AppFieldType.date)) {
      _textController.text = widget.initialValue.toString();
    }
  }

  @override
  void didUpdateWidget(covariant SmartField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      // Update the internal FormField state to match the new prop value.
      // This is crucial when widgets are reused, e.g., in a List where items are removed/reordered.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formFieldKey.currentState?.didChange(widget.initialValue);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use FormField to participate in the parent Form's validation
    return FormField<dynamic>(
      key: _formFieldKey,
      initialValue: widget.initialValue,
      validator: (value) => widget.field.validate(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<dynamic> fieldState) {
        final showsInternalError =
            widget.field.type == AppFieldType.text ||
            widget.field.type == AppFieldType.number ||
            widget.field.type == AppFieldType.email ||
            widget.field.type == AppFieldType.date ||
            widget.field.type == AppFieldType.dropdown ||
            widget.field.type == AppFieldType.reference;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInput(fieldState),
            if (fieldState.hasError && !showsInternalError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInput(FormFieldState<dynamic> fieldState) {
    switch (widget.field.type) {
      case AppFieldType.text:
      case AppFieldType.email:
        return _buildTextField(fieldState);
      case AppFieldType.number:
        return _buildNumberField(fieldState);
      case AppFieldType.date:
        return _buildDatePicker(fieldState);
      case AppFieldType.boolean:
        return _buildBooleanField(fieldState);
      case AppFieldType.dropdown:
        return _buildDropdownField(fieldState);
      case AppFieldType.reference:
        return _buildReferenceDropdown(fieldState);
      case AppFieldType.json:
        return _buildJsonField(fieldState);
      case AppFieldType.list:
        return _buildListField(fieldState);
    }
  }

  Widget _buildTextField(FormFieldState<dynamic> fieldState) {
    // Sync controller if fieldState value changes externally (e.g. reset or list reorder)
    if (fieldState.value != _lastSeenValue) {
      final newText = fieldState.value?.toString() ?? '';
      if (_textController.text != newText) {
        _textController.text = newText;
      }
      _lastSeenValue = fieldState.value;
    }

    return TextFormField(
      controller: _textController,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.field.name,
        border: const OutlineInputBorder(),
        errorText: fieldState.hasError ? fieldState.errorText : null,
      ),
      onChanged: (value) {
        _lastSeenValue = value;
        fieldState.didChange(value);
        widget.onChanged(value);
      },
    );
  }

  Widget _buildNumberField(FormFieldState<dynamic> fieldState) {
    // Sync controller if fieldState value changes externally
    if (fieldState.value != _lastSeenValue) {
      final newText = fieldState.value?.toString() ?? '';
      if (_textController.text != newText) {
        _textController.text = newText;
      }
      _lastSeenValue = fieldState.value;
    }

    return TextFormField(
      controller: _textController,
      readOnly: widget.readOnly,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.field.name,
        border: const OutlineInputBorder(),
        errorText: fieldState.hasError ? fieldState.errorText : null,
      ),
      onChanged: (value) {
        final numValue = num.tryParse(value);
        _lastSeenValue = numValue;
        fieldState.didChange(numValue);
        widget.onChanged(numValue);
      },
    );
  }

  Widget _buildDatePicker(FormFieldState<dynamic> fieldState) {
    // Sync controller if fieldState value changes externally
    if (fieldState.value != _lastSeenValue) {
      final dateValue = fieldState.value as DateTime?;
      final dateString = dateValue?.toIso8601String().substring(0, 10) ?? '';
      if (_textController.text != dateString) {
        _textController.text = dateString;
      }
      _lastSeenValue = fieldState.value;
    }

    return TextFormField(
      controller: _textController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.field.name,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
        errorText: fieldState.hasError ? fieldState.errorText : null,
      ),
      onTap: () async {
        if (widget.readOnly) return;
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: widget.field.startDate ?? DateTime(2000),
          lastDate: widget.field.endDate ?? DateTime(2101),
        );

        if (selectedDate == null) return;

        final dateString = selectedDate.toIso8601String().substring(0, 10);
        _textController.text = dateString;
        _lastSeenValue = selectedDate;
        fieldState.didChange(selectedDate);
        widget.onChanged(selectedDate);
      },
    );
  }

  Widget _buildBooleanField(FormFieldState<dynamic> fieldState) {
    return CheckboxListTile(
      title: Text(widget.field.name),
      value: fieldState.value == true,
      onChanged: widget.readOnly
          ? null
          : (newValue) {
              fieldState.didChange(newValue);
              widget.onChanged(newValue);
            },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildDropdownField(FormFieldState<dynamic> fieldState) {
    return DropdownButtonFormField<String>(
      initialValue: fieldState.value?.toString(),
      decoration: InputDecoration(
        labelText: widget.field.name,
        border: const OutlineInputBorder(),
      ),
      items: widget.field.options
          ?.map(
            (option) => DropdownMenuItem(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: widget.readOnly
          ? null
          : (String? newValue) {
              fieldState.didChange(newValue);
              widget.onChanged(newValue);
            },
    );
  }

  Widget _buildReferenceDropdown(FormFieldState<dynamic> fieldState) {
    final relatedTableId = widget.field.referenceTo;
    if (relatedTableId == null) return const SizedBox.shrink();

    final asyncData = ref.watch(dataProvider);
    final asyncSchema = ref.watch(schemaProvider);

    return asyncSchema.when(
      data: (schema) {
        if (schema == null) return Container();
        final relatedTable = schema.getTable(relatedTableId);
        final displayField = relatedTable?.fields.firstWhere(
          (f) => f.type == AppFieldType.text || f.type == AppFieldType.email,
          orElse: () => relatedTable.fields.first,
        );

        return asyncData.when(
          data: (allData) {
            if (allData == null) return Container();
            final relatedRecords = allData[relatedTableId] ?? [];

            // Ensure the initial value exists in the options to avoid errors
            final initialValue = fieldState.value?.toString();
            final isValidValue = relatedRecords.any(
              (r) => r['_id'] == initialValue,
            );

            return DropdownButtonFormField<String>(
              initialValue: isValidValue ? initialValue : null,
              decoration: InputDecoration(
                labelText: widget.field.name,
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
              onChanged: widget.readOnly
                  ? null
                  : (String? newValue) {
                      fieldState.didChange(newValue);
                      widget.onChanged(newValue);
                    },
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

  Widget _buildJsonField(FormFieldState<dynamic> fieldState) {
    final Map<String, dynamic> currentValue =
        fieldState.value is Map<String, dynamic>
        ? Map.from(fieldState.value)
        : {};

    final subFields = widget.field.fields ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.field.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (subFields.isEmpty)
              const Text("No fields defined for this JSON object."),
            ...subFields.map((subField) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SmartField(
                  field: subField,
                  initialValue: currentValue[subField.id],
                  readOnly: widget.readOnly,
                  onChanged: (newValue) {
                    currentValue[subField.id] = newValue;
                    fieldState.didChange(currentValue);
                    widget.onChanged(currentValue);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildListField(FormFieldState<dynamic> fieldState) {
    final List<dynamic> currentList = fieldState.value is List
        ? List.from(fieldState.value)
        : [];
    final childField = widget.field.child;

    if (childField == null) {
      return const Text("No item schema defined for this list.");
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.field.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (!widget.readOnly)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add a null/default item. The validation will handle it if required.
                      currentList.add(null);
                      fieldState.didChange(currentList);
                      widget.onChanged(currentList);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (currentList.isEmpty) const Text("No items."),
            for (int i = 0; i < currentList.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SmartField(
                        key: ValueKey('${childField.id}_$i'),
                        field: childField,
                        initialValue: currentList[i],
                        readOnly: widget.readOnly,
                        onChanged: (newValue) {
                          currentList[i] = newValue;
                          fieldState.didChange(currentList);
                          widget.onChanged(currentList);
                        },
                      ),
                    ),
                    if (!widget.readOnly)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          currentList.removeAt(i);
                          fieldState.didChange(currentList);
                          widget.onChanged(currentList);
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
