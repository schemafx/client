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

    return Row(
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
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: FloatingActionButton.small(
              elevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              hoverElevation: 0,
              onPressed: () async {
                final id = await Dialogs.showAddTable(context, ref);
                if (id != null && context.mounted) {
                  context.go('/editor/$id');
                }
              },
              child: const Icon(Icons.add),
            ),
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
                        onTap: () => context.go('/editor/$id'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => context.go('/editor/$id'),
                            ),
                            IconButton(
                              tooltip: 'Preview',
                              icon: const Icon(Icons.play_arrow_outlined),
                              onPressed: () => context.go('/start/$id'),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Application'),
                                    content: Text(
                                      'Are you sure you want to delete "$name"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;

                                try {
                                  await ApiService().delete('apps/$id');
                                  ref.invalidate(HomeScreen._appsProvider);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Application deleted'),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete: $e'),
                                    ),
                                  );
                                }
                              },
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
    );
  }
}
