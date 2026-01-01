import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/screens/auth_callback_screen.dart';
import 'package:schemafx/ui/screens/editor_mode_screen.dart';
import 'package:schemafx/ui/screens/login_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';

class SchemaFxApp extends ConsumerWidget {
  const SchemaFxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(errorProvider, (previous, next) {
      if (next == null) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ref
              .read(scaffoldMessengerKeyProvider)
              .currentState
              ?.showSnackBar(
                SnackBar(content: Text(next), backgroundColor: Colors.red),
              );
          ref.read(errorProvider.notifier).clearError();
        } catch (_) {}
      });
    });

    // This router is now simpler and more robust.
    final router = GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthRefreshNotifier(ref),
      routes: [
        GoRoute(path: '/', redirect: (_, _) => '/start/123'),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/callback',
          builder: (context, state) => AuthCallbackScreen(
            token: state.uri.queryParameters['token'],
            error: state.uri.queryParameters['error'],
          ),
        ),
        GoRoute(
          path: '/start/:appId',
          builder: (context, state) => RuntimeModeScreen(),
        ),
        GoRoute(
          path: '/edit/:appId',
          builder: (context, state) => EditorModeScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = ref.watch(authProvider);
        final isAuthenticated =
            authState.asData?.value == AuthState.authenticated;
        final isLoggingIn = state.matchedLocation == '/login';
        final isAuthCallback = state.matchedLocation == '/auth/callback';

        // If the user is on the auth callback, let them proceed.
        if (isAuthCallback) return null;

        // If the user is not authenticated, redirect to the login screen.
        if (!isAuthenticated && !isLoggingIn) {
          // Store the intended location so we can redirect after login.
          Future.microtask(
            () => ref.read(redirectUrlProvider.notifier).set(state.uri),
          );

          return '/login';
        }

        // If the user is authenticated and on the login screen, redirect them.
        if (isAuthenticated && isLoggingIn) {
          final redirectUrl = ref.read(redirectUrlProvider) ?? Uri.parse('/');
          Future.microtask(
            () => ref.read(redirectUrlProvider.notifier).clear(),
          );

          return redirectUrl.toString();
        }

        return null;
      },
    );

    return MaterialApp.router(
      title: 'SchemaFX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(WidgetRef ref) {
    ref.listen(authProvider, (previous, next) => notifyListeners());
  }
}
