import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final connectorsAsync = ref.watch(authConnectorsProvider);

    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      if (next is! AsyncError) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((next.error as Exception).toString()),
          backgroundColor: Colors.red,
        ),
      );
    });

    // Show loading indicator if auth is in progress
    final isAuthLoading = authState.isLoading || authState.isReloading;

    // The router now handles redirection, so we don't need a special
    // loading state here. The login screen will simply be replaced.

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isAuthLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Signing in...'),
                  ],
                )
              : connectorsAsync.when(
                  loading: () => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading sign-in options...'),
                    ],
                  ),
                  error: (error, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading connectors',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(authConnectorsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                  data: (connectors) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: Color(0xFF6750A4),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to SchemaFX',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      ...connectors.map(
                        (connector) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SizedBox(
                            width: 280,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(authProvider.notifier)
                                    .loginWithConnector(
                                      connector['id'] as String,
                                    );
                              },
                              icon: const Icon(Icons.login),
                              label: Text('Sign in with ${connector['name']}'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
