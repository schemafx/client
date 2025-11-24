import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/app.dart';

/// The main entry point of the application.
void main() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  WidgetsFlutterBinding.ensureInitialized();

  // Wrap the app in a ProviderScope for Riverpod
  runApp(const ProviderScope(child: SchemaFxApp()));
}
