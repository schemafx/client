import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/services/secure_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

// Represents the result of an authentication attempt from a popup/redirect.
class AuthResult {
  final String? token;
  final String? error;

  AuthResult({this.token, this.error});
}

// Base class for platform-specific authentication services.
abstract class AuthService {
  Future<AuthResult> loginWithConnector(
    String connectorName,
    String redirectUri,
  );
  Future<void> logout();
}

// Web implementation that uses a full-page redirect.
class WebAuthService implements AuthService {
  final Ref _ref;
  final SecureStorageService _secureStorageService = SecureStorageService();
  WebAuthService(this._ref);

  @override
  Future<AuthResult> loginWithConnector(
    String connectorName,
    String redirectUri,
  ) async {
    final apiService = ApiService();
    final authUrl = Uri.parse(apiService.getAuthUrl(connectorName));

    // Before redirecting, save the user's intended final destination.
    final finalRedirectUrl = _ref.read(redirectUrlProvider)?.toString() ?? '/';
    web.window.sessionStorage.setItem(
      'post_auth_redirect_url',
      finalRedirectUrl,
    );

    final authUrlWithRedirect = authUrl.replace(
      queryParameters: {...authUrl.queryParameters, 'redirectUri': redirectUri},
    );

    // Perform a full-page redirect to the authentication provider.
    web.window.location.href = authUrlWithRedirect.toString();

    // This future will never complete because the page is navigating away.
    // It is awaited by the AuthNotifier, which is fine because the app will
    // be completely reloaded on the callback page.
    return Completer<AuthResult>().future;
  }

  @override
  Future<void> logout() async {
    await _secureStorageService.deleteToken();
  }
}

// Mobile implementation that uses a web view and deep linking.
class MobileAuthService implements AuthService {
  final Ref _ref;
  final SecureStorageService _secureStorageService = SecureStorageService();
  MobileAuthService(this._ref);

  @override
  Future<AuthResult> loginWithConnector(
    String connectorName,
    String redirectUri,
  ) async {
    final apiService = ApiService();
    final authUrl = Uri.parse(apiService.getAuthUrl(connectorName));
    final authUrlWithRedirect = authUrl.replace(
      queryParameters: {...authUrl.queryParameters, 'redirectUri': redirectUri},
    );

    final completer = Completer<AuthResult>();
    _ref.read(authCompleterProvider.notifier).set(completer);

    if (!await launchUrl(authUrlWithRedirect, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch authentication URL');
    }

    return completer.future;
  }

  @override
  Future<void> logout() async {
    await _secureStorageService.deleteToken();
  }
}

// Provider to get the appropriate auth service based on the platform.
final authServiceProvider = Provider<AuthService>((ref) {
  if (kIsWeb) {
    return WebAuthService(ref);
  } else {
    return MobileAuthService(ref);
  }
});
