import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_action.freezed.dart';
part 'app_action.g.dart';

/// Defines the type of an action in a table.
enum AppActionType { add, update, delete, process }

/// Represents a single action within a table.
///
/// An [AppAction] defines the structure of an action in a table, including its
/// [name], [type], and various constraints.
@freezed
sealed class AppAction with _$AppAction {
  /// Creates a new [AppAction].
  const factory AppAction({
    required String id,
    required String name,
    required AppActionType type,
    @Default({}) Map<String, dynamic> config,
  }) = _AppAction;

  const AppAction._();

  /// Creates a new [AppAction] from a JSON object.
  factory AppAction.fromJson(Map<String, dynamic> json) =>
      _$AppActionFromJson(json);
}
