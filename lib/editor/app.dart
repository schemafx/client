import 'package:flutter/material.dart';
import './pages/action_bar.dart';
import './pages/design.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          bottom: 0,
          width: 330,
          height: 600,
          child: DesignScreen(),
        ),
        Positioned(right: 10, top: 10, child: ActionBar()),
      ],
    );
  }
}
