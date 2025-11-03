import 'package:flutter/material.dart';

import 'package:schemafx/editor/components/dialog.dart';
import 'package:schemafx/editor/pages/data.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  String mode = 'Pages';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
          bottom: Radius.zero,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            leading: const Icon(Icons.design_services_outlined, size: 28),
            title: const Text('Design'),
            actions: [
              /*IconButton(
                icon: const Icon(Icons.extension_outlined, size: 28),
                onPressed: () {
                  // TODO: Add Plugins
                },
              ),
              const SizedBox(width: 4)*/
              IconButton(
                icon: const Icon(
                  Icons.control_point_duplicate_outlined,
                  size: 28,
                ),
                tooltip: 'New Source',
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => const DataScreen(),
                  );

                  if (!context.mounted) return;

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const ConnectDataDialog(),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InputChip(
                      label: const Text('Pages'),
                      avatar: const Icon(Icons.splitscreen_outlined),
                      selected: mode == 'Pages',
                      onSelected: (value) {
                        if (value) {
                          setState(() => mode = 'Pages');
                        }
                      },
                      showCheckmark: false,
                    ),
                    InputChip(
                      label: const Text('Assets'),
                      avatar: const Icon(Icons.grid_view_outlined),
                      selected: mode == 'Assets',
                      onSelected: (value) {
                        if (value) {
                          setState(() => mode = 'Assets');
                        }
                      },
                      showCheckmark: false,
                    ),
                    InputChip(
                      label: const Text('Data'),
                      avatar: const Icon(Icons.layers_outlined),
                      selected: false,
                      onSelected: (value) => {
                        value
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DataScreen(),
                              )
                            : Null,
                      },
                      showCheckmark: false,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchBar(
                  elevation: WidgetStateProperty.all(0.0),
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search_outlined),
                  ),
                  hintText: mode == 'Assets'
                      ? 'Search Components'
                      : 'Search Elements',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: mode == 'Assets'
                      ? GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 2,
                              ),

                          itemCount: 80,

                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 18,
                                    bottom: 10,
                                    child: Text(
                                      'Name',
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: 30,
                          itemBuilder: (BuildContext context, int index) {
                            return _PageElement();
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageElement extends StatelessWidget {
  final bool hasChild = false;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Icon(
          hasChild ? Icons.keyboard_arrow_down_outlined : Icons.remove_outlined,
          size: 24,
        ),
        const Icon(Icons.crop_16_9_outlined, size: 24),
        const SizedBox(width: 8.0),
        Text('Onboarding', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );

    return hasChild
        ? Column(
            children: [
              row,
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: _PageElement(),
              ),
            ],
          )
        : row;
  }
}
