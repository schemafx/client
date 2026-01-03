import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/screens/design_screen.dart';
import 'package:schemafx/ui/screens/properties_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';

class EditorModeScreen extends ConsumerStatefulWidget {
  const EditorModeScreen({super.key});

  @override
  ConsumerState<EditorModeScreen> createState() => _EditorModeScreenState();
}

class _EditorModeScreenState extends ConsumerState<EditorModeScreen> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to update the provider after the build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appId = GoRouterState.of(context).pathParameters['appId'];
      if (appId == null) return;

      ref.read(appIdProvider.notifier).setId(appId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
