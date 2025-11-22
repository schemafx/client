import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the current error message.
///
/// This is used to display errors to the user in a consistent way.
class ErrorNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Sets the error message to [message].
  void showError(String message) {
    state = message;
  }

  /// Clears the error message.
  void clearError() {
    state = null;
  }
}

/// A provider that exposes the current error message and allows it to be modified.
final errorProvider = NotifierProvider<ErrorNotifier, String?>(() {
  return ErrorNotifier();
});
