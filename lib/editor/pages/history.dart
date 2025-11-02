import 'package:flutter/material.dart';
import '../components/dialog.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget _buildVersionTile(BuildContext context, bool main) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: main ? Theme.of(context).colorScheme.primaryContainer : null,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          main
              ? SizedBox.shrink()
              : Text('Author', style: Theme.of(context).textTheme.labelMedium),
          Text(main ? 'Main' : 'Feature'),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            main ? 'Published Version' : 'Feature Description',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text('Status • Date • Version'),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        onPressed: () {},
        tooltip: 'Preview',
        icon: Icon(Icons.preview_outlined),
      ),
    );
  }

  Widget _buildChangeTile(BuildContext context, bool? dense) {
    return Column(
      children: [
        ListTile(
          dense: dense,
          contentPadding: EdgeInsetsGeometry.symmetric(
            vertical: dense == true ? 8 : 16,
            horizontal: dense == true ? 32 : 16,
          ),
          tileColor: dense == true
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : Theme.of(context).colorScheme.surfaceContainer,
          leading: Checkbox(value: false, onChanged: (value) {}),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Addition', style: Theme.of(context).textTheme.labelMedium),
              Text('Change on Page'),
            ],
          ),
          subtitle: Text('Author • Date'),
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
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Text('History'),
        bottom: PreferredSize(
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
                  leading: Icon(Icons.history_outlined),
                  title: Text('Versions'),
                  actions: [
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CreateVersionDialog(),
                      ),
                      tooltip: 'Create Version',
                      icon: Icon(Icons.control_point_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsGeometry.only(
                      top: 16,
                      left: 8,
                      right: 8,
                    ),
                    child: Column(
                      spacing: 8,
                      children: [
                        _buildVersionTile(context, true),
                        ...List.generate(
                          15,
                          (index) => _buildVersionTile(context, false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text('Version'),
                  actions: [
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AbandonChangesDialog(),
                      ),
                      tooltip: 'Abandon Changes',
                      icon: Icon(Icons.cancel_outlined),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            PublishChangesDialog(),
                      ),
                      tooltip: 'Publish Changes',
                      icon: Icon(Icons.publish_outlined),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DeleteVersionDialog(),
                      ),
                      tooltip: 'Delete',
                      icon: Icon(Icons.delete_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsGeometry.only(top: 16),
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
