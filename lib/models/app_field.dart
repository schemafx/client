import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_field.freezed.dart';
part 'app_field.g.dart';

/// Defines the data type of a field in a table.
enum AppFieldType {
  /// A plain text field.
  text,

  /// A numeric field.
  number,

  /// A date field.
  date,

  /// An email address field.
  email,

  /// A dropdown field with a list of options.
  dropdown,

  /// A boolean field.
  boolean,

  /// A reference field.
  reference,
}

/// Represents a single field within a table.
///
/// An [AppField] defines the structure of a column in a table, including its
/// [name], [type], and various constraints.
@freezed
sealed class AppField with _$AppField {
  /// Creates a new [AppField].
  const factory AppField({
    /// The unique identifier for this field.
    required String id,

    /// The name of this field.
    required String name,

    /// The data type of this field.
    required AppFieldType type,

    /// The ID of the table this field is related to, if [type] is [AppFieldType.reference].
    String? referenceTo,

    /// Whether this field is required to have a value.
    @Default(false) bool isRequired,

    /// The minimum length of the text, if [type] is [AppFieldType.text].
    int? minLength,

    /// The maximum length of the text, if [type] is [AppFieldType.text].
    int? maxLength,

    /// The minimum value of the number, if [type] is [AppFieldType.number].
    double? minValue,

    /// The maximum value of the number, if [type] is [AppFieldType.number].
    double? maxValue,

    /// The start date, if [type] is [AppFieldType.date].
    DateTime? startDate,

    /// The end date, if [type] is [AppFieldType.date].
    DateTime? endDate,

    /// The list of options for a dropdown field.
    List<String>? options,
  }) = _AppField;

  const AppField._();

  /// Creates a new [AppField] from a JSON object.
  factory AppField.fromJson(Map<String, dynamic> json) =>
      _$AppFieldFromJson(json);

  /// Validates a single field based on its properties.
  String? validate(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'This field is required.';
    }

    if (value == null || value.isEmpty) {
      return null;
    }

    switch (type) {
      case AppFieldType.text:
        if (minLength != null && value.length < minLength!) {
          return 'Must be at least $minLength characters.';
        }

        if (maxLength != null && value.length > maxLength!) {
          return 'Must be no more than $maxLength characters.';
        }

        break;
      case AppFieldType.number:
        final number = double.tryParse(value);

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
        final date = DateTime.tryParse(value);

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

        if (!emailRegex.hasMatch(value)) {
          return 'Must be a valid email address.';
        }

        break;
      case AppFieldType.dropdown:
        if (options != null && !options!.contains(value)) {
          return 'Invalid option.';
        }

        break;
      case AppFieldType.boolean:
        // No validation needed for boolean, as it's handled by the checkbox
        break;
      default:
        break;
    }

    return null;
  }
}
