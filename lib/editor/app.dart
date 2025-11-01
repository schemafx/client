import 'package:flutter/material.dart';
import './pages/action_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Positioned(right: 10, top: 10, child: ActionBar())],
    );
  }
}
