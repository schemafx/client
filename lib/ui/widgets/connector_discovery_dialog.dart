import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  List<String> _currentPath = [];
  List<Map<String, dynamic>>? _discoveryResults;

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
          _connectors = connectors;
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

  Future<void> _queryConnector({List<String>? path}) async {
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
      );

      if (mounted) {
        setState(() {
          _discoveryResults = results;
          _currentPath = queryPath;
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

  Future<void> _selectConnector(String id, String name) async {
    setState(() {
      _selectedConnectorId = id;
      _selectedConnectorName = name;
      _currentPath = [];
      _discoveryResults = null;
    });

    await _queryConnector();
  }

  Future<void> _connectTable(Map<String, dynamic> item) async {
    if (_selectedConnectorId == null) return;
    final path = List<String>.from(item['path'] as List);

    try {
      await ref
          .read(schemaProvider.notifier)
          .addTableFromConnector(_selectedConnectorId!, path);

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
    if (_currentPath.isEmpty) {
      setState(() {
        _selectedConnectorId = null;
        _selectedConnectorName = null;
        _discoveryResults = null;
      });
    } else {
      _queryConnector(path: List<String>.from(_currentPath)..removeLast());
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
                        _currentPath.isEmpty
                            ? '/'
                            : '/${_currentPath.join('/')}',
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

        return ListTile(
          leading: const Icon(Icons.electrical_services),
          title: Text(connector['name'] ?? 'Unknown'),
          onTap: () =>
              _selectConnector(connector['id'], connector['name'] ?? 'Unknown'),
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
                  onPressed: () => _queryConnector(
                    path: List<String>.from(item['path'] as List),
                  ),
                ),
              if (canConnect)
                ElevatedButton(
                  onPressed: () => _connectTable(item),
                  child: const Text('Connect'),
                ),
            ],
          ),
          onTap: canExplore
              ? () => _queryConnector(
                  path: List<String>.from(item['path'] as List),
                )
              : null,
        );
      },
    );
  }
}
