import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_field.dart';

part 'app_table.freezed.dart';
part 'app_table.g.dart';

/// Represents a table within the application's schema.
///
/// An [AppTable] holds a collection of [AppField]s which define its structure.
@freezed
sealed class AppTable with _$AppTable {
  /// Creates a new [AppTable].
  const factory AppTable({
    /// The unique identifier for this table.
    required String id,

    /// The name of this table.
    required String name,

    /// The list of fields in this table.
    @Default([]) List<AppField> fields,
  }) = _AppTable;

  const AppTable._();

  /// Creates a new [AppTable] from a JSON object.
  factory AppTable.fromJson(Map<String, dynamic> json) =>
      _$AppTableFromJson(json);
}
