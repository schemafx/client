import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/application_providers.dart';
import 'package:schemafx/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  Future<AuthState> build() async {
    final secureStorageService = ref.watch(secureStorageServiceProvider);
    final token = await secureStorageService.getToken();
    return token != null ? AuthState.authenticated : AuthState.unauthenticated;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final token = await _authRepository.login(username, password);
      final secureStorageService = ref.read(secureStorageServiceProvider);
      await secureStorageService.saveToken(token);
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final secureStorageService = ref.read(secureStorageServiceProvider);
      await secureStorageService.deleteToken();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
