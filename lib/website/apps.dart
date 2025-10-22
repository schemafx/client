import 'package:flutter/material.dart';

class Apps extends StatelessWidget {
  const Apps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _NavigationSidebar(),
          Expanded(child: _MainContent()),
        ],
      ),
    );
  }
}

class _NavigationSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      groupAlignment: 0,
      labelType: NavigationRailLabelType.all,
      leading: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          // TODO: Opens Connection modal.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Use the custom widget defined below
              return _ConnectDataDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.apps_outlined),
          selectedIcon: Icon(Icons.apps),
          label: Text('Apps'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Learn'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.copy_all_outlined),
          selectedIcon: Icon(Icons.copy_all),
          label: Text('Templates'),
        ),
      ],
    );
  }
}

class _MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.interests, color: Colors.grey),
              ),
              const SizedBox(width: 15),
              Text('SchemaFX', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 100, // TODO: Replace with actual data.
              itemBuilder: (context, index) {
                return _ApplicationListItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.interests, color: Colors.grey),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Owner', style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    'Application',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Status · Description',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              tooltip: 'Open',
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                // TODO: Define menu use.
              },

              // Required: Builds the list of menu items
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.open_in_browser),
                      const SizedBox(width: 8),
                      const Text('Open in Editor'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.open_in_new),
                      const SizedBox(width: 8),
                      const Text('Open'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectDataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      contentPadding: EdgeInsets.zero,

      title: Text(
        'Connect Data',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: ListBody(
          children: List.filled(5, [
            OutlinedButton(
              onPressed: () {
                // TODO: Add behavior
              },
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensures the container wraps the content
                children: <Widget>[
                  Icon(Icons.square_outlined, size: 24.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Connector',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ]).expand((toElements) => toElements).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.start,
    );
  }
}
