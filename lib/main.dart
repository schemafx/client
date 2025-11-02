import 'package:flutter/material.dart';
import './editor/app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchemaFX',
      home: Container(color: Color.fromARGB(255, 229, 229, 229), child: App()),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 103, 80, 164),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          actionsPadding: EdgeInsetsGeometry.only(right: 8),
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}
