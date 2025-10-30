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
