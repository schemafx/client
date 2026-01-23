import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:schemafx/providers/providers.dart';
import 'package:schemafx/services/api_service.dart';

class ConnectorDiscoveryDialog extends ConsumerStatefulWidget {
  const ConnectorDiscoveryDialog({super.key});

  @override
  ConsumerState<ConnectorDiscoveryDialog> createState() =>
      _ConnectorDiscoveryDialogState();
}

class _ConnectorDiscoveryDialogState
    extends ConsumerState<ConnectorDiscoveryDialog> {
  final ApiService _apiService = ApiService();

  bool _loading = true;
  String? _error;

  List<Map<String, dynamic>>? _connectors;
  String? _selectedConnectorId;
  String? _selectedConnectorName;
  String? _selectedConnectionId;

  // Connection options form state
  List<Map<String, dynamic>>? _connectionOptions;
  Map<String, dynamic> _connectionOptionsValues = {};
  Map<String, TextEditingController> _connectionOptionsControllers = {};
  bool _submittingOptions = false;

  List<String> _currentPath = [];
  List<Map<String, dynamic>>? _discoveryResults;

  List<List<String>> _pathHistory = [];
  List<List<String>> _nameHistory = [];
  List<String> _currentPathNames = [];

  @override
  void dispose() {
    for (final controller in _connectionOptionsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadConnectors();
  }

  Future<void> _loadConnectors() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final connectors = await _apiService.getConnectors();

      if (mounted) {
        setState(() {
          _connectors = connectors
              .where((connector) => connector['supportsData'] as bool)
              .toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load connectors: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _queryConnector({
    List<String>? path,
    List<String>? names,
    bool pushHistory = false,
  }) async {
    if (_selectedConnectorId == null) return;
    final queryPath = path ?? _currentPath;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _apiService.queryConnector(
        _selectedConnectorId!,
        queryPath,
        connectionId: _selectedConnectionId,
      );

      if (mounted) {
        setState(() {
          if (pushHistory) {
            _pathHistory.add(List.from(_currentPath));
            _nameHistory.add(List.from(_currentPathNames));
          }

          _discoveryResults = results;
          _currentPath = queryPath;

          if (names != null) _currentPathNames = names;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to query connector: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _selectConnector(
    String id,
    String name, {
    String? connectionId,
  }) async {
    setState(() {
      _selectedConnectorId = id;
      _selectedConnectorName = name;
      _selectedConnectionId = connectionId;
      _currentPath = [];
      _discoveryResults = null;
      _pathHistory = [];
      _nameHistory = [];
      _currentPathNames = [];
    });

    await _queryConnector();
  }

  Future<void> _connectTable(Map<String, dynamic> item) async {
    if (_selectedConnectorId == null) return;
    final path = List<String>.from(item['path'] as List);

    try {
      final newId = await ref
          .read(schemaProvider.notifier)
          .addTableFromConnector(
            _selectedConnectorId!,
            path,
            connectionId: _selectedConnectionId,
          );

      if (mounted) Navigator.of(context).pop(newId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add table: $e')));
      }
    }
  }

  void _navigateUp() {
    if (_pathHistory.isNotEmpty) {
      final prevPath = _pathHistory.removeLast();
      final prevNames = _nameHistory.removeLast();
      _queryConnector(path: prevPath, names: prevNames);
    } else if (_connectionOptions != null) {
      // Go back from discovery to connection options form
      setState(() {
        _discoveryResults = null;
        _currentPath = [];
        _pathHistory = [];
        _nameHistory = [];
        _currentPathNames = [];
        _selectedConnectionId = null;
      });
    } else {
      // Dispose controllers when going back to connector list
      for (final controller in _connectionOptionsControllers.values) {
        controller.dispose();
      }
      _connectionOptionsControllers = {};

      setState(() {
        _selectedConnectorId = null;
        _selectedConnectorName = null;
        _selectedConnectionId = null;
        _discoveryResults = null;
        _currentPath = [];
        _pathHistory = [];
        _nameHistory = [];
        _currentPathNames = [];
        _connectionOptions = null;
        _connectionOptionsValues = {};
      });
    }
  }

  void _showConnectionOptionsForm(
    String connectorId,
    String name,
    List<Map<String, dynamic>> options,
  ) {
    // Dispose old controllers
    for (final controller in _connectionOptionsControllers.values) {
      controller.dispose();
    }
    _connectionOptionsControllers = {};

    setState(() {
      _selectedConnectorId = connectorId;
      _selectedConnectorName = name;
      _connectionOptions = options;
      _connectionOptionsValues = {};

      // Initialize default values and controllers
      for (final option in options) {
        final id = option['id'] as String;
        final type = option['type'] as String;
        if (type == 'boolean') {
          _connectionOptionsValues[id] = false;
        } else {
          _connectionOptionsControllers[id] = TextEditingController();
        }
      }
    });
  }

  Future<void> _submitConnectionOptions() async {
    if (_selectedConnectorId == null || _connectionOptions == null) return;

    // Sync controller values to _connectionOptionsValues before validation
    for (final option in _connectionOptions!) {
      final id = option['id'] as String;
      final type = option['type'] as String;
      final controller = _connectionOptionsControllers[id];
      if (controller != null) {
        if (type == 'number') {
          _connectionOptionsValues[id] = num.tryParse(controller.text);
        } else {
          _connectionOptionsValues[id] = controller.text;
        }
      }
    }

    // Validate required fields
    for (final option in _connectionOptions!) {
      final id = option['id'] as String;
      final isOptional = option['optional'] as bool? ?? false;
      final value = _connectionOptionsValues[id];

      if (!isOptional &&
          (value == null || (value is String && value.isEmpty))) {
        setState(() {
          _error = 'Please fill in all required fields';
        });

        return;
      }
    }

    setState(() {
      _submittingOptions = true;
      _error = null;
    });

    try {
      final connectionId = await _apiService.submitConnectionOptions(
        _selectedConnectorId!,
        _connectionOptionsValues,
      );

      if (mounted) {
        setState(() {
          _selectedConnectionId = connectionId;
          _submittingOptions = false;
        });

        await _queryConnector();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to connect: $e';
          _submittingOptions = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;
    if (_selectedConnectorId == null) {
      title = 'Select Connector';
    } else if (_connectionOptions != null && _selectedConnectionId == null) {
      title = 'Connect to $_selectedConnectorName';
    } else {
      title = 'Browse $_selectedConnectorName';
    }

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 600,
        height: 400,
        child: Column(
          children: [
            if (_selectedConnectorId != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _navigateUp,
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentPathNames.length > 3
                            ? '.../${_currentPathNames.sublist(_currentPathNames.length - 3).join('/')}'
                            : _currentPathNames.isEmpty
                            ? '/'
                            : '/${_currentPathNames.join('/')}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedConnectorId == null
                  ? _loadConnectors
                  : () => _queryConnector(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_selectedConnectorId == null) return _buildConnectorList();

    // Show connection options form if options are present and not yet connected
    if (_connectionOptions != null && _selectedConnectionId == null) {
      return _buildConnectionOptionsForm();
    }

    return _buildDiscoveryList();
  }

  Widget _buildConnectionOptionsForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: ListView(
          children: [
            for (final option in _connectionOptions!)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildOptionField(
                  option['id'] as String,
                  option['name'] as String? ?? option['id'] as String,
                  option['type'] as String,
                  option['optional'] as bool? ?? false,
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _submittingOptions ? null : _submitConnectionOptions,
        child: _submittingOptions
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Connect'),
      ),
    ],
  );

  Widget _buildOptionField(
    String id,
    String name,
    String type,
    bool isOptional,
  ) {
    final label = isOptional ? name : '$name *';

    switch (type) {
      case 'boolean':
        return SwitchListTile(
          title: Text(label),
          value: _connectionOptionsValues[id] as bool? ?? false,
          onChanged: (value) {
            setState(() {
              _connectionOptionsValues[id] = value;
            });
          },
        );
      case 'number':
        return TextField(
          controller: _connectionOptionsControllers[id],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          enableSuggestions: false,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _connectionOptionsValues[id] = num.tryParse(value);
          },
        );
      case 'password':
      case 'text':
      default:
        return TextField(
          controller: _connectionOptionsControllers[id],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          enableSuggestions: false,
          obscureText: type == 'password',
          maxLines: type == 'password' ? 1 : null,
          onChanged: (value) {
            _connectionOptionsValues[id] = value;
          },
        );
    }
  }

  Widget _buildConnectorList() {
    if (_connectors == null || _connectors!.isEmpty) {
      return const Center(child: Text('No connectors available.'));
    }

    return ListView.builder(
      itemCount: _connectors!.length,
      itemBuilder: (context, index) {
        final connector = _connectors![index];
        final connection = connector['connection'];
        final requiresConnection =
            connector['requiresConnection'] as bool? ?? false;
        final connectionOptions = connector['connectionOptions'];
        final hasConnectionOptions =
            connectionOptions != null &&
            connectionOptions is List &&
            connectionOptions.isNotEmpty;
        final name = connector['name'] ?? 'Unknown';

        return ListTile(
          leading: const Icon(Icons.electrical_services),
          title: Text(name),
          subtitle: connection != null
              ? Text(connection['name'] ?? 'Unknown Connection')
              : null,
          trailing: connection == null && requiresConnection
              ? FilledButton(
                  onPressed: () {
                    if (hasConnectionOptions) {
                      _showConnectionOptionsForm(
                        connector['id'],
                        name,
                        List<Map<String, dynamic>>.from(connectionOptions),
                      );
                    } else {
                      final url = _apiService.getAuthUrl(connector['id']);
                      launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
                    }
                  },
                  child: const Text('Connect'),
                )
              : null,
          onTap: () {
            if (connection != null) {
              _selectConnector(
                connector['id'],
                name,
                connectionId: connection['id'],
              );
            } else if (!requiresConnection) {
              _selectConnector(connector['id'], name);
            } else if (hasConnectionOptions) {
              _showConnectionOptionsForm(
                connector['id'],
                name,
                List<Map<String, dynamic>>.from(connectionOptions),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildDiscoveryList() {
    if (_discoveryResults == null || _discoveryResults!.isEmpty) {
      return const Center(child: Text('No items found.'));
    }

    return ListView.separated(
      itemCount: _discoveryResults!.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _discoveryResults![index];
        final name = item['name'] as String? ?? 'Unknown';
        final capabilities = List<String>.from(
          item['capabilities'] as List? ?? [],
        );

        final isUnavailable = capabilities.contains('Unavailable');
        final canExplore = capabilities.contains('Explore');
        final canConnect = capabilities.contains('Connect');

        final schema = ref.watch(schemaProvider).value;
        final itemPath = List<String>.from(item['path'] as List);
        final alreadyAdded =
            schema?.tables.any(
              (t) =>
                  t.connector == _selectedConnectorId &&
                  listEquals(t.path, itemPath),
            ) ==
            true;

        return ListTile(
          enabled: !isUnavailable,
          leading: Icon(canExplore ? Icons.folder : Icons.table_chart),
          title: Text(name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canExplore)
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'Explore',
                  onPressed: () {
                    final newNames = List<String>.from(_currentPathNames)
                      ..add(name);
                    _queryConnector(
                      path: List<String>.from(item['path'] as List),
                      names: newNames,
                      pushHistory: true,
                    );
                  },
                ),
              if (canConnect)
                ElevatedButton(
                  onPressed: alreadyAdded ? null : () => _connectTable(item),
                  child: alreadyAdded
                      ? const Text('Added')
                      : const Text('Connect'),
                ),
            ],
          ),
          onTap: canExplore
              ? () {
                  final newNames = List<String>.from(_currentPathNames)
                    ..add(name);
                  _queryConnector(
                    path: List<String>.from(item['path'] as List),
                    names: newNames,
                    pushHistory: true,
                  );
                }
              : null,
        );
      },
    );
  }
}
