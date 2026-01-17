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
      } else {
        return _buildDesktopLayout(cardColor);
      }
    });
  }

  /// Desktop layout: 3-column side-by-side
  Widget _buildDesktopLayout(Color cardColor) {
    return Row(
      children: [
        Container(width: 300, color: cardColor, child: const DesignScreen()),
        const VerticalDivider(),
        const Expanded(child: RuntimeModeScreen()),
        const VerticalDivider(),
        Container(
          width: 300,
          color: cardColor,
          child: const PropertiesScreen(),
        ),
      ],
    );
  }

  /// Tablet layout: 2-column with narrower side panels
  Widget _buildTabletLayout(Color cardColor) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Design'),
              Tab(text: 'Preview'),
              Tab(text: 'Properties'),
            ],
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            isScrollable: true,
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(color: cardColor, child: const DesignScreen()),
                Container(color: cardColor, child: const RuntimeModeScreen()),
                Container(color: cardColor, child: const PropertiesScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile layout: Full-screen tabs
  Widget _buildMobileLayout(Color cardColor) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: cardColor,
            child: const TabBar(
              tabs: [
                Tab(text: 'Design'),
                Tab(text: 'Preview'),
                Tab(text: 'Properties'),
              ],
              isScrollable: true,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(color: cardColor, child: const DesignScreen()),
                Container(color: cardColor, child: const RuntimeModeScreen()),
                Container(color: cardColor, child: const PropertiesScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
