import 'package:flutter/material.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadiusGeometry.directional(
          topStart: Radius.circular(24),
          topEnd: Radius.circular(24),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.build_outlined),
            title: const Text('Properties'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Data"),
                Tab(text: "Settings"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _PropertiesDataPanel(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _PropertiesSettingsPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertiesDataPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final len = 15;

    return ListView.separated(
      itemBuilder: (context, index) => index == 0
          ? const SizedBox()
          : index == len + 1
          ? ExpansionTile(
              title: const Text('Advanced'),
              shape: const Border(),
              childrenPadding: const EdgeInsets.only(top: 16),
              children: [
                Column(
                  spacing: 16,
                  children: List.generate(
                    5,
                    // TODO: Appropriate fields.
                    (index) => TextFormField(
                      initialValue: 'Name',
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : TextFormField(
              initialValue: 'Name',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: len + 2,
    );
  }
}

class _PropertiesSettingsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final len = 15;

    return ListView.separated(
      itemBuilder: (context, index) => index == 0
          ? const SizedBox()
          : index == len + 1
          ? ExpansionTile(
              title: const Text('Advanced'),
              shape: const Border(),
              childrenPadding: const EdgeInsets.only(top: 16),
              children: [
                Column(
                  spacing: 16,
                  children: List.generate(
                    5,
                    // TODO: Appropriate fields.
                    (index) => TextFormField(
                      initialValue: 'Name',
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : TextFormField(
              initialValue: 'Name',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: len + 2,
    );
  }
}
