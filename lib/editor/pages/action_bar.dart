import 'package:flutter/material.dart';
import '../components/dialog.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadiusGeometry.all(Radius.circular(1000)),
      ),
      padding: EdgeInsetsGeometry.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          IconButton.filledTonal(
            visualDensity: VisualDensity(vertical: -2),
            onPressed: () {
              // TODO: Handle Undo
            },
            icon: Icon(Icons.undo),
          ),
          IconButton.filledTonal(
            visualDensity: VisualDensity(vertical: -2),
            onPressed: () {
              // TODO: Handle Redo
            },
            icon: Icon(Icons.redo),
          ),
          IconButton.filledTonal(
            visualDensity: VisualDensity(vertical: -2),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ShareDialog(),
            ),
            icon: Icon(Icons.person_add),
          ),
          IconButton.filledTonal(
            visualDensity: VisualDensity(vertical: -2),
            onPressed: () {
              // TODO: Handle Branding
            },
            icon: Icon(Icons.color_lens),
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
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1000),
                      bottomLeft: Radius.circular(1000),
                      topRight: Radius.circular(350),
                      bottomRight: Radius.circular(350),
                    ),
                  ),
                ),
                icon: Icon(Icons.rocket_launch),
                label: const Text('Publish'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Handle Advanced Publish
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
