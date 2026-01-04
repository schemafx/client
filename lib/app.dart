import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/services/auth_service.dart';
import 'package:schemafx/ui/screens/auth_callback_screen.dart';
import 'package:schemafx/ui/screens/editor_mode_screen.dart';
import 'package:schemafx/ui/screens/login_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';
import 'package:schemafx/ui/screens/home_screen.dart';
import 'package:schemafx/ui/widgets/header.dart';

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

    return MaterialApp.router(
      title: 'SchemaFX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthRefreshNotifier(ref),
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/logout',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        redirect: (context, state) async {
          await ref.read(authServiceProvider).logout();
          return '/login';
        },
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (context, state) => AuthCallbackScreen(
          code: state.uri.queryParameters['code'],
          error: state.uri.queryParameters['error'],
        ),
      ),
      GoRoute(
        path: '/start/:appId',
        builder: (context, state) => RuntimeModeScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppHeader(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/edit/:appId',
            builder: (context, state) => EditorModeScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
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
        Future.microtask(() => ref.read(redirectUrlProvider.notifier).clear());

        return redirectUrl.toString();
      }

      return null;
    },
  );
});

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (previous, next) => notifyListeners());
  }
}
