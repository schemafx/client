import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/ui/screens/design_screen.dart';
import 'package:schemafx/ui/screens/properties_screen.dart';
import 'package:schemafx/ui/screens/runtime_mode_screen.dart';
import 'package:schemafx/ui/utils/responsive.dart';

class EditorModeScreen extends ConsumerWidget {
  const EditorModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardColor = Theme.of(context).cardColor;

    return ResponsiveUtils.buildResponsive(context, (context, width) {
      if (ResponsiveUtils.isMobile(width)) {
        return _buildMobileLayout(cardColor);
      } else if (ResponsiveUtils.isTablet(width)) {
        return _buildTabletLayout(cardColor);
      }

      return _buildDesktopLayout(cardColor);
    });
  }

  /// Desktop layout: 3-column side-by-side
  Widget _buildDesktopLayout(Color cardColor) => Row(
    children: [
      Container(width: 300, color: cardColor, child: const DesignScreen()),
      const VerticalDivider(),
      const Expanded(child: RuntimeModeScreen()),
      const VerticalDivider(),
      Container(width: 300, color: cardColor, child: const PropertiesScreen()),
    ],
  );

  /// Tablet layout: 2-column with narrower side panels
  Widget _buildTabletLayout(Color cardColor) => DefaultTabController(
    length: 3,
    child: Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              Container(color: cardColor, child: const DesignScreen()),
              Container(color: cardColor, child: const PropertiesScreen()),
              Container(color: cardColor, child: const RuntimeModeScreen()),
            ],
          ),
        ),
        TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.design_services_outlined), text: 'Design'),
            Tab(icon: Icon(Icons.build_outlined), text: 'Properties'),
            Tab(icon: Icon(Icons.play_circle), text: 'Preview'),
          ],
        ),
      ],
    ),
  );

  /// Mobile layout: Full-screen tabs
  Widget _buildMobileLayout(Color cardColor) => DefaultTabController(
    length: 3,
    child: Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              Container(color: cardColor, child: const DesignScreen()),
              Container(color: cardColor, child: const RuntimeModeScreen()),
              Container(color: cardColor, child: const PropertiesScreen()),
            ],
          ),
        ),
        TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.palette), text: 'Design'),
            Tab(icon: Icon(Icons.play_circle), text: 'Preview'),
            Tab(icon: Icon(Icons.settings), text: 'Properties'),
          ],
        ),
      ],
    ),
  );
}
