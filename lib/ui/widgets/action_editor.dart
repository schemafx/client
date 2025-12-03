import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schemafx/models/models.dart';
import 'package:schemafx/providers/providers.dart';

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
                (action) => ListTile(
                  title: Text(action.name),
                  subtitle: Text(action.type.name),
                  trailing: Row(
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
              const SizedBox(height: 16),
              Center(
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
            ],
          ),
        ),
      ],
    );
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
  Widget build(BuildContext context) {
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
          child: ListView(
            padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<AppActionType>(
                initialValue: widget.action.type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: AppActionType.values
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.onUpdate(widget.action.copyWith(type: value));
                  }
                },
              ),
              const SizedBox(height: 24),
              if (widget.action.type == AppActionType.process)
                _ProcessConfigEditor(
                  action: widget.action,
                  allActions: widget.allActions,
                  onUpdate: widget.onUpdate,
                ),
            ],
          ),
        ),
      ],
    );
  }
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
    final actionIds = List<String>.from(widget.action.config['actions'] ?? []);
    _items = actionIds
        .map((id) => (key: UniqueKey().toString(), actionId: id))
        .toList();
  }

  @override
  void didUpdateWidget(covariant _ProcessConfigEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newActionIds = List<String>.from(
      widget.action.config['actions'] ?? [],
    );
    final currentActionIds = _items.map((e) => e.actionId).toList();

    if (!listEquals(newActionIds, currentActionIds)) {
      _initItems();
    }
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
        const SizedBox(height: 8),
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
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
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
              if (value != null) {
                setState(() {
                  _items.add((key: UniqueKey().toString(), actionId: value));
                });
                _updateItems();
              }
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
