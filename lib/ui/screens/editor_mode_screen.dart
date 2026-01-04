import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/ui/screens/design_screen.dart';
import 'package:schemafx/ui/screens/properties_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';

class EditorModeScreen extends ConsumerWidget {
  const EditorModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardColor = Theme.of(context).cardColor;

    return Row(
      children: [
        Container(width: 300, color: cardColor, child: DesignScreen()),
        const VerticalDivider(),
        const Expanded(child: RuntimeModeScreen()),
        const VerticalDivider(),
        Container(width: 300, color: cardColor, child: PropertiesScreen()),
      ],
    );
  }
}
