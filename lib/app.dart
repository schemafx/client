import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/screens/editor_mode_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';

/// The root widget of the application.
///
/// This widget is responsible for setting up the [MaterialApp] and switching
/// between the [EditorModeScreen] and [RuntimeModeScreen] based on the
/// current [AppMode].
class SchemaFxApp extends ConsumerWidget {
  /// Creates a new [SchemaFxApp].
  const SchemaFxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(errorProvider, (previous, next) {
      if (next != null) {
        // We use a post frame callback to ensure the ScaffoldMessenger is available.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(scaffoldMessengerKeyProvider)
              .currentState
              ?.showSnackBar(
                SnackBar(content: Text(next), backgroundColor: Colors.red),
              );

          // Clear the error after showing it.
          ref.read(errorProvider.notifier).clearError();
        });
      }
    });

    return MaterialApp.router(
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      title: 'SchemaFX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: '/edit/123',
        routes: [
          GoRoute(path: '/', builder: (context, state) => RuntimeModeScreen()),
          GoRoute(
            path: '/start/:id',
            builder: (context, state) => RuntimeModeScreen(),
          ),
          GoRoute(
            path: '/edit/:id',
            builder: (context, state) => EditorModeScreen(),
          ),
        ],
      ),
    );
  }
}
