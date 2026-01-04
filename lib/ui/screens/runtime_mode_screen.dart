import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/widgets/runtime_canvas.dart';
import 'package:schemafx/ui/widgets/runtime_sidebar.dart';

class RuntimeModeScreen extends ConsumerWidget {
  const RuntimeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
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
