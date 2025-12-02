import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_field.freezed.dart';
part 'app_field.g.dart';

/// Defines the data type of a field in a table.
enum AppFieldType { text, number, date, email, dropdown, boolean, reference, json, list }

/// Represents a single field within a table.
///
/// An [AppField] defines the structure of a column in a table, including its
/// [name], [type], and various constraints.
@freezed
sealed class AppField with _$AppField {
  /// Creates a new [AppField].
  const factory AppField({
    required String id,
    required String name,
    required AppFieldType type,
    String? referenceTo,
    @Default(false) bool isRequired,
    int? minLength,
    int? maxLength,
    double? minValue,
    double? maxValue,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? options,
    List<AppField>? fields,
    AppField? child,
  }) = _AppField;

  const AppField._();

  /// Creates a new [AppField] from a JSON object.
  factory AppField.fromJson(Map<String, dynamic> json) =>
      _$AppFieldFromJson(json);

  /// Validates a single field based on its properties.
  String? validate(dynamic value) {
    if (isRequired) {
      if (value == null) return 'This field is required.';
      if (value is String && value.isEmpty) return 'This field is required.';
      if (value is List && value.isEmpty) return 'This field is required.';
      if (value is Map && value.isEmpty) return 'This field is required.';
    }

    if (value == null) return null;
    if (value is String && value.isEmpty) return null;

    switch (type) {
      case AppFieldType.text:
        final strValue = value.toString();
        if (minLength != null && strValue.length < minLength!) {
          return 'Must be at least $minLength characters.';
        }

        if (maxLength != null && strValue.length > maxLength!) {
          return 'Must be no more than $maxLength characters.';
        }

        break;
      case AppFieldType.number:
        final number = value is num ? value.toDouble() : double.tryParse(value.toString());

        if (number == null) {
          return 'Must be a valid number.';
        }

        if (minValue != null && number < minValue!) {
          return 'Must be at least $minValue.';
        }

        if (maxValue != null && number > maxValue!) {
          return 'Must be no more than $maxValue.';
        }

        break;
      case AppFieldType.date:
        final date = value is DateTime ? value : DateTime.tryParse(value.toString());

        if (date == null) {
          return 'Invalid date format.';
        }

        if (startDate != null && date.isBefore(startDate!)) {
          return 'Date must be after $startDate.';
        }

        if (endDate != null && date.isAfter(endDate!)) {
          return 'Date must be before $endDate.';
        }

        break;
      case AppFieldType.email:
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

        if (!emailRegex.hasMatch(value.toString())) {
          return 'Must be a valid email address.';
        }

        break;
      case AppFieldType.dropdown:
        if (options != null && !options!.contains(value.toString())) {
          return 'Invalid option.';
        }

        break;
      case AppFieldType.boolean:
        // No validation needed for boolean, as it's handled by the checkbox
        break;
      case AppFieldType.json:
        if (value is! Map) return 'Invalid JSON format.';
        break;
      case AppFieldType.list:
        if (value is! List) return 'Invalid List format.';
        break;
      default:
        break;
    }

    return null;
  }
}
