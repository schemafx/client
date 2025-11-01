import 'package:flutter/material.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  String mode = 'Pages';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
          bottom: Radius.zero,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                onPressed: () {
                  // TODO: Handle connect button press
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
                      label: Text('Pages'),
                      avatar: Icon(Icons.splitscreen_outlined),
                      selected: mode == 'Pages',
                      onSelected: (value) => {
                        value ? setState(() => mode = 'Pages') : Null,
                      },
                      showCheckmark: false,
                    ),
                    InputChip(
                      label: Text('Assets'),
                      avatar: Icon(Icons.grid_view_outlined),
                      selected: mode == 'Assets',
                      onSelected: (value) => {
                        value ? setState(() => mode = 'Assets') : Null,
                      },
                      showCheckmark: false,
                    ),
                    InputChip(
                      label: Text('Data'),
                      avatar: Icon(Icons.layers_outlined),
                      selected: false,
                      onSelected: (value) => {
                        value ? /* TODO: Open the Data view */ Null : Null,
                      },
                      showCheckmark: false,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchBar(
                  elevation: WidgetStateProperty.all(0.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                color: const Color(0xFFF0EFF2),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 18,
                                    bottom: 10,
                                    child: Text(
                                      'Name',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
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
        Icon(Icons.crop_16_9_outlined, size: 24),
        const SizedBox(width: 8.0),
        Text('Onboarding', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );

    return hasChild
        ? Column(
            children: [
              row,
              Padding(
                padding: EdgeInsetsGeometry.only(left: 24),
                child: _PageElement(),
              ),
            ],
          )
        : row;
  }
}
