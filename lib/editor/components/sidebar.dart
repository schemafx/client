import 'package:flutter/material.dart';

class NewRowSideSheet extends StatelessWidget {
  const NewRowSideSheet({super.key});

  Widget _buildTextField({
    required String label,
    required String initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop(),
            ),
            forceMaterialTransparency: true,
            title: Text('New Row'),
            actions: [Container()],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(vertical: 16),
              child: Column(
                spacing: 16,
                children: [
                  _buildTextField(label: 'Column', initialValue: 'Value'),
                  _buildTextField(label: 'Column', initialValue: '0.00'),
                  _buildTextField(label: 'Column', initialValue: '100.00%'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 2,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Handle Insert
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
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
                    child: const Text('Insert'),
                  ),
                  MenuAnchor(
                    builder:
                        (
                          BuildContext context,
                          MenuController controller,
                          Widget? child,
                        ) {
                          return ElevatedButton(
                            onPressed: () => controller.isOpen
                                ? controller.close()
                                : controller.open(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
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
                            child: const Icon(Icons.arrow_drop_down, size: 24),
                          );
                        },
                    menuChildren: [
                      const SizedBox(height: 5),
                      MenuItemButton(
                        leadingIcon: Icon(Icons.wrap_text_outlined),
                        onPressed: () {
                          // TODO: Handle Insert & New
                          Navigator.of(context).pop();
                        },
                        child: Text('Insert & New'),
                      ),
                      MenuItemButton(
                        leadingIcon: Icon(Icons.file_upload_outlined),
                        onPressed: () {
                          // TODO: Handle Import
                          Navigator.of(context).pop();
                        },
                        child: Text('Import'),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),

              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SourceSettingsSideSheet extends StatelessWidget {
  const SourceSettingsSideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_outlined),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  forceMaterialTransparency: true,
                  title: Text('Source Settings'),
                  actions: [Container()],
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: "Source"),
                      Tab(text: "Performance"),
                    ],
                  ),
                ),

                body: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        spacing: 16,
                        children: [
                          const SizedBox(height: 0),
                          TextFormField(
                            initialValue: 'Name',
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          TextFormField(
                            initialValue: 'Create , Update , Delete',
                            decoration: InputDecoration(
                              labelText: 'Update Modes',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          TextFormField(
                            initialValue: 'English (UK)',
                            decoration: InputDecoration(
                              labelText: 'Locale',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        spacing: 16,
                        children: [
                          const SizedBox(height: 0),
                          TextFormField(
                            initialValue: 'Filter',
                            decoration: InputDecoration(
                              labelText: 'Row-Level Security',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          TextFormField(
                            initialValue: '3,600',
                            decoration: InputDecoration(
                              labelText: 'Cache Expiry (s)',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle Save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Save'),
              ),

              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColumnSettingsSideSheet extends StatefulWidget {
  const ColumnSettingsSideSheet({super.key});

  @override
  State<ColumnSettingsSideSheet> createState() =>
      _ColumnSettingsSideSheetState();
}

class _ColumnSettingsSideSheetState extends State<ColumnSettingsSideSheet> {
  String? _type = 'Text';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop(),
            ),
            forceMaterialTransparency: true,
            title: Text('Column'),
            actions: [Container()],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    initialValue: 'Column',
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _type,
                    onChanged: (newValue) => setState(() {
                      _type = newValue;
                    }),
                    items: ['Text', 'Number', 'Percent', 'Date']
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                  TextFormField(
                    initialValue: '1',
                    decoration: InputDecoration(
                      labelText: 'Min. Length',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    initialValue: '20',
                    decoration: InputDecoration(
                      labelText: 'Max. Length',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    initialValue: 'Text',
                    decoration: InputDecoration(
                      labelText: 'Default Value',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle Save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text('Save'),
              ),

              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurface,
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BrandingSideSheet extends StatelessWidget {
  const BrandingSideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop(),
            ),
            forceMaterialTransparency: true,
            title: Text('Branding'),
            actions: [Container()],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    initialValue: 'Column',
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    initialValue: 'Roboto',
                    decoration: InputDecoration(
                      labelText: 'Font',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle Save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Save'),
              ),

              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
