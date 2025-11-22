import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_view.freezed.dart';
part 'app_view.g.dart';

/// The type of view to display.
enum AppViewType {
  /// A view that displays a table of records.
  table,

  /// A view that displays a form for creating a new record.
  form,
}

/// A view is a user-definable screen or layout for displaying and interacting
/// with data from a table.
@freezed
sealed class AppView with _$AppView {
  /// Creates a new [AppView].
  const factory AppView({
    /// The unique identifier of the view.
    required String id,

    /// The name of the view.
    required String name,

    /// The unique identifier of the table this view is associated with.
    required String tableId,

    /// The type of view to display.
    required AppViewType type,

    /// The list of field IDs to display in the view.
    required List<String> fields,
  }) = _AppView;

  const AppView._();

  /// Creates a new [AppView] from a JSON object.
  factory AppView.fromJson(Map<String, dynamic> json) =>
      _$AppViewFromJson(json);
}
