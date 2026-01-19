import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/services/auth_service.dart';
import 'package:web/web.dart' as web;

class AuthCallbackScreen extends ConsumerStatefulWidget {
  final String? code;
  final String? error;

  const AuthCallbackScreen({super.key, this.code, this.error});

  @override
  ConsumerState<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_handleCallback);
  }

  Future<void> _handleCallback() async {
    // On mobile, the app is resumed via a deep link. We need to complete the
    // auth flow using the completer that was stored by the AuthService.
    if (!kIsWeb) {
      final completer = ref.read(authCompleterProvider);
      if (completer == null || completer.isCompleted) {
        if (mounted) context.go('/login');
        return;
      }

      if (widget.error != null) {
        completer.complete(AuthResult(error: widget.error));
      } else if (widget.code != null) {
        completer.complete(AuthResult(code: widget.code));
      } else {
        completer.completeError(
          Exception('Authentication failed: No code or error received.'),
        );
      }

      ref.read(authCompleterProvider.notifier).clear();
      if (mounted) context.go('/');
      return;
    }

    // On web, the app has performed a full-page redirect. We now handle the
    // code and then navigate to the user's original destination.
    try {
      if (widget.error != null) throw Exception(widget.error);

      if (widget.code != null) {
        await ref
            .read(authProvider.notifier)
            .handleCodeFromServer(widget.code!);

        // After auth is complete, retrieve and clear the saved redirect URL.
        final redirectUrl =
            web.window.sessionStorage.getItem('post_auth_redirect_url') ?? '/';

        web.window.sessionStorage.removeItem('post_auth_redirect_url');

        if (mounted) context.go(redirectUrl);
      } else {
        throw Exception('Authentication failed: No code received.');
      }
    } catch (e) {
      // If anything goes wrong, just send the user back to the login page.
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Processing...'),
        ],
      ),
    ),
  );
}
