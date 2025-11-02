import 'package:flutter/material.dart';
import 'package:schemafx/editor/app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchemaFX',
      home: const App(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          actionsPadding: EdgeInsets.only(right: 8),
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}
