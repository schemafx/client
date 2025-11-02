import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:schemafx/editor/components/column_type_button.dart';
import 'package:schemafx/editor/models/drawer_state.dart';
import 'package:schemafx/editor/components/sidebar.dart';
import 'package:schemafx/editor/components/dialog.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text('Data'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1),
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _DataScreenSource(),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: _DataScreenTable()),
        ],
      ),
    );
  }
}

class _DataScreenSource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppBar(
          leading: const Icon(Icons.dns_outlined),
          title: const Text('Sources'),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => const ConnectDataDialog(),
              ),
              tooltip: 'New Source',
              icon: const Icon(Icons.control_point_duplicate_outlined),
            ),
          ],
        ),
        SearchBar(
          hintText: 'Search Sources',
          backgroundColor: WidgetStateProperty.all(
            colorScheme.surfaceContainerHighest,
          ),
          elevation: WidgetStateProperty.all(0),
          trailing: const [Icon(Icons.search), SizedBox(width: 8)],
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            itemCount: 15,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: index == 1 ? colorScheme.surfaceContainerHigh : null,
              title: const Text('Table'),
            ),
          ),
        ),
      ],
    );
  }
}

class _DataScreenTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppBar(
          leading: const Icon(Icons.table_chart_outlined),
          title: const Text('Table'),
          actions: [
            IconButton(
              onPressed: () => context.read<DrawerStateModel>().showDrawer(
                const ColumnSettingsSideSheet(),
              ),
              tooltip: 'Create Column',
              icon: const Icon(Icons.add_outlined),
            ),
            IconButton(
              onPressed: () => context.read<DrawerStateModel>().showDrawer(
                const NewRowSideSheet(),
              ),
              tooltip: 'Add Row',
              icon: const Icon(Icons.playlist_add_outlined),
            ),
            IconButton(
              onPressed: () => context.read<DrawerStateModel>().showDrawer(
                const SourceSettingsSideSheet(),
              ),
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                            borderRadius: const BorderRadiusGeometry.all(
                              Radius.circular(16),
                            ),
                          ),
                          columns: List.generate(
                            3,
                            (index) => DataColumn(
                              label: Row(
                                spacing: 16,
                                children: [
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: ColumnTypeButton(
                                      onSelected: (type) {},
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Column'),
                                      Text(
                                        'Text',
                                        style: theme.textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          rows: List.generate(
                            15,
                            (index) => DataRow(
                              cells: List.generate(
                                3,
                                (colIdx) => const DataCell(
                                  Text('...'),
                                  placeholder: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
