import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schemafx/models/app_view.dart';

import 'app_table.dart';

part 'app_schema.freezed.dart';
part 'app_schema.g.dart';

/// Represents the entire application schema.
///
/// The [AppSchema] is the root of the data model, containing all the [tables]
/// that define the application.
@freezed
sealed class AppSchema with _$AppSchema {
  /// Creates a new [AppSchema].
  const factory AppSchema({
    /// The unique identifier for this schema.
    required String id,

    /// The name of this schema.
    required String name,

    /// The list of tables in this schema.
    @Default([]) List<AppTable> tables,

    /// The list of views in this schema.
    @Default([]) List<AppView> views,
  }) = _AppSchema;

  const AppSchema._();

  /// Creates a new [AppSchema] from a JSON object.
  factory AppSchema.fromJson(Map<String, dynamic> json) =>
      _$AppSchemaFromJson(json);

  /// Returns the table with the given [id].
  ///
  /// Returns `null` if no table with the given [id] is found.
  AppTable? getTable(String id) {
    try {
      return tables.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
