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
        borderRadius: BorderRadiusGeometry.directional(
          topStart: Radius.circular(24),
          topEnd: Radius.circular(24),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.build_outlined),
            title: Text('Properties'),
            bottom: TabBar(
              tabs: [
                Tab(text: "Data"),
                Tab(text: "Settings"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Data
              SingleChildScrollView(
                padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    List.generate(
                      15,
                      // TODO: Appropriate fields.
                      (index) => TextFormField(
                        initialValue: 'Name',
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    [
                      ExpansionTile(
                        title: const Text('Advanced'),
                        shape: Border(),
                        childrenPadding: EdgeInsetsGeometry.only(top: 16),
                        children: [
                          Column(
                            spacing: 16,
                            children: List.generate(
                              5,
                              // TODO: Appropriate fields.
                              (index) => TextFormField(
                                initialValue: 'Name',
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ].expand((innerList) => innerList).toList(),
                ),
              ),
              // Settings
              SingleChildScrollView(
                padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    List.generate(
                      15,
                      // TODO: Handle Appropriate Fields
                      (index) => TextFormField(
                        initialValue: 'Name',
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    [
                      ExpansionTile(
                        title: const Text('Advanced'),
                        shape: Border(),
                        childrenPadding: EdgeInsetsGeometry.only(top: 16),
                        children: [
                          Column(
                            spacing: 16,
                            children: List.generate(
                              5,
                              // TODO: Appropriate fields.
                              (index) => TextFormField(
                                initialValue: 'Name',
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ].expand((innerList) => innerList).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
