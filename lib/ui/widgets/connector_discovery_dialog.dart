import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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

  List<String> _currentPath = [];
  List<Map<String, dynamic>>? _discoveryResults;

  List<List<String>> _pathHistory = [];
  List<List<String>> _nameHistory = [];
  List<String> _currentPathNames = [];

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
      await ref
          .read(schemaProvider.notifier)
          .addTableFromConnector(
            _selectedConnectorId!,
            path,
            connectionId: _selectedConnectionId,
          );

      if (mounted) Navigator.of(context).pop();
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
    } else {
      setState(() {
        _selectedConnectorId = null;
        _selectedConnectorName = null;
        _selectedConnectionId = null;
        _discoveryResults = null;
        _currentPath = [];
        _pathHistory = [];
        _nameHistory = [];
        _currentPathNames = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _selectedConnectorId == null
            ? 'Select Connector'
            : 'Browse $_selectedConnectorName',
      ),
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
    return _buildDiscoveryList();
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
                    final url = _apiService.getAuthUrl(connector['id']);
                    launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
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
                  onPressed: () => _connectTable(item),
                  child: const Text('Connect'),
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
