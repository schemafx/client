import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/ui/widgets/dialogs.dart';

/// A simple screen that shows a navigation rail on the left and
/// a list of applications fetched from `/api/apps` on the right.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final _appsProvider = FutureProvider<List<Map<String, dynamic>>>((
    ref,
  ) async {
    final api = ApiService();
    final data = await api.get('apps');
    return List<Map<String, dynamic>>.from(data);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(_appsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Applications'), centerTitle: false),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.apps_outlined),
                selectedIcon: Icon(Icons.apps),
                label: Text('Apps'),
              ),
            ],
            leading: FloatingActionButton.small(
              onPressed: () async {
                final id = await Dialogs.showAddTable(context, ref);
                if (id != null && context.mounted) {
                  context.go('/edit/$id');
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
          const VerticalDivider(width: 1),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: appsAsync.when(
                data: (apps) {
                  if (apps.isEmpty) {
                    return Center(
                      child: Text(
                        'No applications found.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: apps.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      final id = app['id']?.toString() ?? '';
                      final name = app['name']?.toString() ?? id;

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(name),
                          contentPadding: EdgeInsets.all(8),
                          onTap: () => context.go('/edit/$id'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => context.go('/edit/$id'),
                              ),
                              IconButton(
                                tooltip: 'Preview',
                                icon: const Icon(Icons.play_arrow_outlined),
                                onPressed: () => context.go('/start/$id'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) =>
                    Center(child: Text('Failed to load applications: $e')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
