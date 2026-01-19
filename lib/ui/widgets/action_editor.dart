import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/ui/utils/responsive.dart';

class ActionListSideSheet extends ConsumerStatefulWidget {
  const ActionListSideSheet({super.key});

  @override
  ConsumerState<ActionListSideSheet> createState() =>
      _ActionListSideSheetState();
}

class _ActionListSideSheetState extends ConsumerState<ActionListSideSheet> {
  String? _selectedActionId;

  @override
  Widget build(BuildContext context) {
    final table = ref.watch(selectedEditorTableProvider);
    final schema = ref.watch(schemaProvider).value;

    if (table == null || schema == null) {
      return const Center(child: Text('No table selected'));
    }

    // Ensure we have the latest version of the table from the schema
    final currentTable = schema.tables.firstWhere(
      (t) => t.id == table.id,
      orElse: () => table,
    );

    if (_selectedActionId != null) {
      final action = currentTable.actions
          .where((a) => a.id == _selectedActionId)
          .firstOrNull;

      if (action != null) {
        return _ActionEditor(
          action: action,
          allActions: currentTable.actions,
          onBack: () => setState(() => _selectedActionId = null),
          onUpdate: (updatedAction) {
            ref
                .read(schemaProvider.notifier)
                .updateElement(
                  updatedAction,
                  'actions',
                  parentId: currentTable.id,
                );
          },
        );
      }
    }

    return ResponsiveUtils.buildResponsive(context, (context, width) {
      final isMobile = ResponsiveUtils.isMobile(width);

      return Column(
        children: [
          AppBar(
            title: const Text('Actions'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...currentTable.actions.map(
                  (action) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8.0 : 0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      title: Text(action.name),
                      subtitle: Text(action.type.name),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8.0 : 16.0,
                      ),
                      trailing: isMobile
                          ? PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit),
                                      const SizedBox(width: 8),
                                      const Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete),
                                      const SizedBox(width: 8),
                                      const Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  setState(() {
                                    _selectedActionId = action.id;
                                  });
                                } else if (value == 'delete') {
                                  ref
                                      .read(schemaProvider.notifier)
                                      .deleteElement(
                                        action.id,
                                        'actions',
                                        parentId: currentTable.id,
                                      );
                                }
                              },
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _selectedActionId = action.id;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    ref
                                        .read(schemaProvider.notifier)
                                        .deleteElement(
                                          action.id,
                                          'actions',
                                          parentId: currentTable.id,
                                        );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: isMobile ? double.infinity : null,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Action'),
                      onPressed: () async {
                        final newAction = AppAction(
                          id: 'action_${DateTime.now().millisecondsSinceEpoch}',
                          name: 'New Action',
                          type: AppActionType.add,
                        );

                        await ref
                            .read(schemaProvider.notifier)
                            .addElement(
                              newAction,
                              'actions',
                              parentId: currentTable.id,
                            );

                        if (mounted) {
                          setState(() {
                            _selectedActionId = newAction.id;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _ActionEditor extends StatefulWidget {
  final AppAction action;
  final List<AppAction> allActions;
  final VoidCallback onBack;
  final ValueChanged<AppAction> onUpdate;

  const _ActionEditor({
    required this.action,
    required this.allActions,
    required this.onBack,
    required this.onUpdate,
  });

  @override
  State<_ActionEditor> createState() => _ActionEditorState();
}

class _ActionEditorState extends State<_ActionEditor> {
  @override
  Widget build(BuildContext context) =>
      ResponsiveUtils.buildResponsive(context, (context, width) {
        final isMobile = ResponsiveUtils.isMobile(width);
        final padding = ResponsiveUtils.responsivePadding(width);

        return Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
              title: Text('Edit ${widget.action.name}'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 600,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.action.name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          widget.onUpdate(widget.action.copyWith(name: value));
                        },
                      ),
                      SizedBox(height: padding.top),
                      DropdownButtonFormField<AppActionType>(
                        initialValue: widget.action.type,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: AppActionType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          widget.onUpdate(widget.action.copyWith(type: value));
                        },
                      ),
                      SizedBox(height: padding.top * 1.5),
                      if (widget.action.type == AppActionType.process)
                        _ProcessConfigEditor(
                          action: widget.action,
                          allActions: widget.allActions,
                          onUpdate: widget.onUpdate,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

class _ProcessConfigEditor extends StatefulWidget {
  final AppAction action;
  final List<AppAction> allActions;
  final ValueChanged<AppAction> onUpdate;

  const _ProcessConfigEditor({
    required this.action,
    required this.allActions,
    required this.onUpdate,
  });

  @override
  State<_ProcessConfigEditor> createState() => _ProcessConfigEditorState();
}

class _ProcessConfigEditorState extends State<_ProcessConfigEditor> {
  late List<({String key, String actionId})> _items;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  void _initItems() {
    _items = List<String>.from(
      widget.action.config['actions'] ?? [],
    ).map((id) => (key: UniqueKey().toString(), actionId: id)).toList();
  }

  @override
  void didUpdateWidget(covariant _ProcessConfigEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newActionIds = List<String>.from(
      widget.action.config['actions'] ?? [],
    );

    final currentActionIds = _items.map((e) => e.actionId).toList();
    if (!listEquals(newActionIds, currentActionIds)) _initItems();
  }

  void _updateItems() {
    widget.onUpdate(
      widget.action.copyWith(
        config: {
          ...widget.action.config,
          'actions': _items.map((e) => e.actionId).toList(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter available actions: include only Update, Delete, and Process types.
    // Allow adding the same action multiple times and adding the action itself.
    final availableActions = widget.allActions
        .where(
          (a) =>
              a.type == AppActionType.update ||
              a.type == AppActionType.delete ||
              a.type == AppActionType.process,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Process Steps', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (_items.length < 2)
          Column(
            children: [
              for (int i = 0; i < _items.length; i++)
                _buildListTile(i, showDragHandle: false),
            ],
          )
        else
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) newIndex -= 1;
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
              _updateItems();
            },
            children: [
              for (int i = 0; i < _items.length; i++)
                _buildListTile(i, showDragHandle: true),
            ],
          ),
        const SizedBox(height: 16),
        if (availableActions.isNotEmpty)
          DropdownButtonFormField<String>(
            key: ValueKey('add_step_${_items.length}'),
            decoration: const InputDecoration(
              labelText: 'Add Step',
              border: OutlineInputBorder(),
            ),
            items: availableActions
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _items.add((key: UniqueKey().toString(), actionId: value));
              });

              _updateItems();
            },
            initialValue: null,
            hint: const Text('Select an action to add'),
          )
        else
          const Text('No more actions available to add.'),
      ],
    );
  }

  Widget _buildListTile(int index, {required bool showDragHandle}) {
    final item = _items[index];
    return ListTile(
      key: ValueKey(item.key),
      title: Text(
        widget.allActions
            .firstWhere(
              (a) => a.id == item.actionId,
              orElse: () => AppAction(
                id: item.actionId,
                name: 'Unknown Action',
                type: AppActionType.add,
              ),
            )
            .name,
      ),
      leading: CircleAvatar(child: Text('${index + 1}')),
      minLeadingWidth: 40,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });

              _updateItems();
            },
          ),
          if (showDragHandle) const Icon(Icons.drag_handle),
        ],
      ),
    );
  }
}
