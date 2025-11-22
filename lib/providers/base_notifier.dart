import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/ui_providers.dart';

abstract class BaseNotifier<T> extends AsyncNotifier<T> {
  Future<void> mutate(
    Future<T> Function() mutation,
    String successMessage,
  ) async {
    final scaffoldMessenger = ref.read(scaffoldMessengerKeyProvider);

    try {
      scaffoldMessenger.currentState?.showSnackBar(
        const SnackBar(content: Text('Saving...')),
      );

      state = await AsyncValue.guard(() => mutation());

      scaffoldMessenger.currentState?.hideCurrentSnackBar();
      scaffoldMessenger.currentState?.showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      scaffoldMessenger.currentState?.hideCurrentSnackBar();
      scaffoldMessenger.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(
            scaffoldMessenger.currentContext!,
          ).colorScheme.error,
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }
}
