import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/widgets/runtime_canvas.dart';
import 'package:schemafx/ui/widgets/runtime_sidebar.dart';

class RuntimeModeScreen extends ConsumerStatefulWidget {
  const RuntimeModeScreen({super.key});

  @override
  ConsumerState<RuntimeModeScreen> createState() => _RuntimeModeScreenState();
}

class _RuntimeModeScreenState extends ConsumerState<RuntimeModeScreen> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to update the provider after the build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appId = GoRouterState.of(context).pathParameters['appId'];
      if (appId == null) return;

      ref.read(appIdProvider.notifier).setId(appId);
    });
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(schemaProvider)
      .when(
        data: (schema) => schema == null
            ? Container()
            : Scaffold(
                appBar: AppBar(title: Text(schema.name)),
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RuntimeSidebar(),
                    Expanded(child: RuntimeCanvas()),
                  ],
                ),
              ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      );
}
