import 'package:flutter/material.dart';

class DeleteVersionDialog extends StatelessWidget {
  const DeleteVersionDialog({super.key, this.onConfirm});
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Version"),
      content: const Text(
        "Do you wish to abandon this version?\nYou can still recover it later.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }

            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}

class AbandonChangesDialog extends StatelessWidget {
  const AbandonChangesDialog({super.key, this.onConfirm});
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Abandon Changes"),
      content: const Text(
        "Do you wish to abandon these changes?\nYou will still be able to recover them later.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }

            Navigator.of(context).pop();
          },
          child: const Text("Abandon"),
        ),
      ],
    );
  }
}

class PublishChangesDialog extends StatelessWidget {
  const PublishChangesDialog({super.key, this.onConfirm});
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Publish Changes"),
      content: const Text(
        "Do you wish to publish changes?\nThose will be directly available to your users.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }

            Navigator.of(context).pop();
          },
          child: const Text("Publish"),
        ),
      ],
    );
  }
}

class CreateVersionDialog extends StatelessWidget {
  CreateVersionDialog({super.key, this.onConfirm});
  final void Function(String name, String description)? onConfirm;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Version"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "A version lets you work on features without affecting the live, published application.",
            ),
            TextFormField(
              initialValue: "Name",
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              initialValue: "Description",
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(_nameController.text, _descriptionController.text);
            }

            Navigator.of(context).pop();
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}

class ConnectDataDialog extends StatelessWidget {
  const ConnectDataDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Connect Data"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => OutlinedButton(
              onPressed: () {
                // TODO: Handle Connector
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.square_outlined), Text("Connector")],
                ),
              ),
            ),
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text("Share"),
      content: SizedBox(
        width: 400,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const TabBar(
              tabs: [
                Tab(text: "Users"),
                Tab(text: "Identity"),
              ],
            ),
            body: TabBarView(
              children: [
                // Users
                Column(
                  spacing: 16,
                  children: [
                    const SizedBox(height: 0),
                    SearchBar(
                      hintText: 'Add or Search',
                      backgroundColor: WidgetStateProperty.all(
                        colorScheme.surfaceContainerHighest,
                      ),
                      elevation: WidgetStateProperty.all(0),
                      trailing: [Icon(Icons.search), SizedBox(width: 8)],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 16,
                          children: List.generate(
                            15,
                            // TODO: Handle Users Generation.
                            (index) => ListTile(
                              title: const Text('user@example.com'),
                              subtitle: const Text('Role'),
                              trailing: MenuAnchor(
                                builder:
                                    (
                                      BuildContext context,
                                      MenuController controller,
                                      Widget? child,
                                    ) {
                                      return IconButton(
                                        onPressed: () => controller.isOpen
                                            ? controller.close()
                                            : controller.open(),
                                        icon: const Icon(
                                          Icons.more_vert_outlined,
                                        ),
                                      );
                                    },
                                menuChildren: [
                                  const SizedBox(height: 5),
                                  MenuItemButton(
                                    leadingIcon: const Icon(
                                      Icons.square_outlined,
                                    ),
                                    onPressed: () {},
                                    child: const Text('Option'),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Identity
                Column(
                  spacing: 16,
                  children: [
                    const SizedBox(height: 0),
                    SearchBar(
                      hintText: 'Search',
                      backgroundColor: WidgetStateProperty.all(
                        colorScheme.surfaceContainerHighest,
                      ),
                      elevation: WidgetStateProperty.all(0),
                      trailing: const [Icon(Icons.search), SizedBox(width: 8)],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 16,
                          children: List.generate(
                            15,
                            // TODO: Handle Connectors
                            (index) => ListTile(
                              leading: const Icon(Icons.square_outlined),
                              title: const Text('Connector'),
                              trailing: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.link_outlined),
          tooltip: 'Copy Sharing Link',
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
        TextButton(
          onPressed: () => {
            // TODO: Handle Save
            Navigator.of(context).pop(),
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
