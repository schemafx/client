import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/services/api_service.dart';
import 'package:schemafx/ui/utils/responsive.dart';
import 'package:schemafx/ui/widgets/dialogs.dart';

/// A simple screen that shows a navigation rail on the left and
/// a list of applications fetched from `/api/apps` on the right.
class EditorHomeScreen extends ConsumerWidget {
  const EditorHomeScreen({super.key});

  static final _appsProvider =
      FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
        final api = ApiService();
        final data = await api.get('apps');
        return List<Map<String, dynamic>>.from(data);
      });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(_appsProvider);

    return ResponsiveUtils.buildResponsive(context, (context, width) {
      if (ResponsiveUtils.isMobile(width)) {
        return _buildMobileLayout(context, ref, appsAsync);
      } else {
        return _buildDesktopLayout(context, ref, appsAsync);
      }
    });
  }

  /// Desktop layout: Navigation rail + content
  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Map<String, dynamic>>> appsAsync,
  ) {
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
        Expanded(child: _buildContent(context, ref, appsAsync)),
      ],
    );
  }

  /// Mobile layout: Bottom app bar + full-screen content
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Map<String, dynamic>>> appsAsync,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Applications'), centerTitle: true),
      body: _buildContent(context, ref, appsAsync),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final id = await Dialogs.showAddTable(context, ref);
          if (id != null && context.mounted) context.go('/editor/$id');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Shared content area
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Map<String, dynamic>>> appsAsync,
  ) {
    return Padding(
      padding: context.responsivePadding,
      child: appsAsync.when(
        data: (apps) {
          if (apps.isEmpty) {
            return Center(
              child: Text(
                'Seems like there are no applications so far. Start by creating one!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            itemCount: apps.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: context.responsiveSpacing),
            itemBuilder: (context, index) {
              final app = apps[index];
              final id = app['id']?.toString() ?? '';
              final name = app['name']?.toString() ?? id;

              return _buildAppCard(context, ref, id, name);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            Center(child: Text('Failed to load applications: $e')),
      ),
    );
  }

  /// Build app card with responsive button layout
  Widget _buildAppCard(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: context.isMobile
          ? Column(
              children: [
                ListTile(
                  title: Text(name),
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () => context.go('/editor/$id'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit'),
                          onPressed: () => context.go('/editor/$id'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow_outlined),
                          label: const Text('Preview'),
                          onPressed: () => context.go('/start/$id'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                          onPressed: () =>
                              _showDeleteDialog(context, ref, id, name),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListTile(
              title: Text(name),
              contentPadding: const EdgeInsets.all(8),
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
                    onPressed: () => _showDeleteDialog(context, ref, id, name),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ApiService().delete('apps/$id');
      ref.invalidate(EditorHomeScreen._appsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Application deleted')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }
}
