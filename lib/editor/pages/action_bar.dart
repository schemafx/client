import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:schemafx/editor/components/sidebar.dart';
import 'package:schemafx/editor/models/drawer_state.dart';
import 'package:schemafx/editor/components/dialog.dart';
import 'package:schemafx/editor/pages/history.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visualDensity = const VisualDensity(vertical: -2);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(1000),
      ),
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          IconButton.filledTonal(
            visualDensity: visualDensity,
            onPressed: () {
              // TODO: Handle Undo
            },
            icon: const Icon(Icons.undo),
          ),
          IconButton.filledTonal(
            visualDensity: visualDensity,
            onPressed: () {
              // TODO: Handle Redo
            },
            icon: const Icon(Icons.redo),
          ),
          IconButton.filledTonal(
            visualDensity: visualDensity,
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ShareDialog(),
            ),
            icon: const Icon(Icons.person_add),
          ),
          IconButton.filledTonal(
            visualDensity: visualDensity,
            onPressed: () => context.read<DrawerStateModel>().showDrawer(
              const BrandingSideSheet(),
            ),
            icon: const Icon(Icons.color_lens),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Handle Publish
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1000),
                      bottomLeft: Radius.circular(1000),
                      topRight: Radius.circular(350),
                      bottomRight: Radius.circular(350),
                    ),
                  ),
                ),
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Publish'),
              ),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const HistoryScreen(),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1000),
                      bottomRight: Radius.circular(1000),
                      topLeft: Radius.circular(350),
                      bottomLeft: Radius.circular(350),
                    ),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.manage_history, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
