import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_view.freezed.dart';
part 'app_view.g.dart';

/// The type of view to display.
enum AppViewType { table, form }

/// A view is a user-definable screen or layout for displaying and interacting
/// with data from a table.
@freezed
sealed class AppView with _$AppView {
  /// Creates a new [AppView].
  const factory AppView({
    required String id,
    required String name,
    required String tableId,
    required AppViewType type,
    @Default({}) Map<String, dynamic> config,
  }) = _AppView;

  const AppView._();

  /// Creates a new [AppView] from a JSON object.
  factory AppView.fromJson(Map<String, dynamic> json) =>
      _$AppViewFromJson(json);
}
