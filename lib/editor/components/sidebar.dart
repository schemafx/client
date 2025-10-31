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
