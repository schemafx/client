import 'package:flutter/material.dart';
import 'package:schemafx/editor/components/dialog.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget _buildVersionTile(BuildContext context, bool main) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: main ? colorScheme.primaryContainer : null,
      selectedTileColor: colorScheme.surfaceContainerHighest,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          main
              ? SizedBox.shrink()
              : Text('Author', style: textTheme.labelMedium),
          Text(main ? 'Main' : 'Feature'),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            main ? 'Published Version' : 'Feature Description',
            style: textTheme.labelLarge,
          ),
          const Text('Status • Date • Version'),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        onPressed: () {},
        tooltip: 'Preview',
        icon: const Icon(Icons.preview_outlined),
      ),
    );
  }

  Widget _buildChangeTile(BuildContext context, bool? dense) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        ListTile(
          dense: dense,
          contentPadding: EdgeInsets.symmetric(
            vertical: dense == true ? 8 : 16,
            horizontal: dense == true ? 32 : 16,
          ),
          tileColor: dense == true
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surfaceContainer,
          leading: Checkbox(value: false, onChanged: (value) {}),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Addition', style: theme.textTheme.labelMedium),
              Text('Change on Page'),
            ],
          ),
          subtitle: const Text('Author • Date'),
          isThreeLine: true,
          trailing: dense == true
              ? null
              : IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_drop_down_outlined),
                ),
        ),
        if (dense != true)
          ...List.generate(5, (index) => _buildChangeTile(context, true)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text('History'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1),
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                AppBar(
                  leading: const Icon(Icons.history_outlined),
                  title: const Text('Versions'),
                  actions: [
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CreateVersionDialog(),
                      ),
                      tooltip: 'Create Version',
                      icon: const Icon(Icons.control_point_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) =>
                        _buildVersionTile(context, index == 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('Version'),
                  actions: [
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const AbandonChangesDialog(),
                      ),
                      tooltip: 'Abandon Changes',
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const PublishChangesDialog(),
                      ),
                      tooltip: 'Publish Changes',
                      icon: const Icon(Icons.publish_outlined),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const DeleteVersionDialog(),
                      ),
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsGeometry.only(top: 16),
                    child: Column(
                      children: List.generate(
                        15,
                        (index) => _buildChangeTile(context, false),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
