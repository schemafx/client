import 'package:flutter/material.dart';

class DeleteVersionDialog extends StatelessWidget {
  const DeleteVersionDialog({super.key, this.onConfirm});
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Version"),
      content: Text(
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
      title: Text("Abandon Changes"),
      content: SingleChildScrollView(
        child: Text(
          "Do you wish to abandon these changes?\nYou will still be able to recover them later.",
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
      title: Text("Publish Changes"),
      content: SingleChildScrollView(
        child: Text(
          "Do you wish to publish changes?\nThose will be directly available to your users.",
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
      title: Text("Create Version"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A version lets you work on features without affecting the live, published application.",
            ),
            TextFormField(
              initialValue: "Name",
              decoration: InputDecoration(
                labelText: "Name",
                border: const OutlineInputBorder(),
              ),
            ),
            TextFormField(
              initialValue: "Description",
              decoration: InputDecoration(
                labelText: "Description",
                border: const OutlineInputBorder(),
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
              child: Center(
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
    return AlertDialog(
      title: Text("Share"),
      content: SizedBox(
        width: 400,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: TabBar(
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
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                              title: Text('user@example.com'),
                              subtitle: Text('Role'),
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
                                        icon: Icon(Icons.more_vert_outlined),
                                      );
                                    },
                                menuChildren: [
                                  const SizedBox(height: 5),
                                  MenuItemButton(
                                    leadingIcon: Icon(Icons.square_outlined),
                                    onPressed: () {},
                                    child: Text('Option'),
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
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                            // TODO: Handle Connectors
                            (index) => ListTile(
                              leading: Icon(Icons.square_outlined),
                              title: Text('Connector'),
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
          icon: Icon(Icons.link_outlined),
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
