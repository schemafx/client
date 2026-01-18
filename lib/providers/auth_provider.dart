import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/application_providers.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/services/auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

enum AuthState { initial, authenticated, unauthenticated }

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final secureStorageService = ref.watch(secureStorageServiceProvider);
    final token = await secureStorageService.getToken();
    return token != null ? AuthState.authenticated : AuthState.unauthenticated;
  }

  Future<void> loginWithConnector(String connectorName) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      // Determine the redirect URI based on the platform.
      final String redirectUri;
      if (kIsWeb) {
        redirectUri = Uri.parse(
          web.window.location.origin,
        ).replace(path: '/auth/callback').toString();
      } else {
        // This should be your mobile app's custom scheme.
        redirectUri = 'schemafx://auth/callback';
      }
      final result = await authService.loginWithConnector(
        connectorName,
        redirectUri,
      );

      if (result.error != null) {
        throw Exception(result.error);
      }

      if (result.code != null) {
        await handleCodeFromServer(result.code!);
      } else {
        throw Exception('Authentication failed: No token or code received.');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> handleCodeFromServer(String code) async {
    try {
      final token = await ApiService().getTokenFromCode(code);
      await handleTokenFromServer(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> handleTokenFromServer(String token) async {
    try {
      final secureStorageService = ref.read(secureStorageServiceProvider);
      await secureStorageService.saveToken(token);
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final secureStorageService = ref.read(secureStorageServiceProvider);
      await secureStorageService.deleteToken();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final authConnectorsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final apiService = ApiService();
  final connectors = await apiService.getConnectors();

  return connectors
      .where(
        (c) =>
            c['requiresConnection'] == true && c['connectionOptions'] == null,
      )
      .toList();
});
