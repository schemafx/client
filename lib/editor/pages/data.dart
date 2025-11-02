import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/column_type_button.dart';
import '../models/drawer_state.dart';
import '../components/sidebar.dart';
import '../components/dialog.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Text('Data'),
        bottom: PreferredSize(
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
              child: Column(
                children: [
                  AppBar(
                    leading: Icon(Icons.dns_outlined),
                    title: Text('Sources'),
                    actions: [
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ConnectDataDialog(),
                        ),
                        tooltip: 'New Source',
                        icon: Icon(Icons.control_point_duplicate_outlined),
                      ),
                    ],
                  ),
                  SearchBar(
                    hintText: 'Search Sources',
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    elevation: WidgetStateProperty.all(0),
                    trailing: [Icon(Icons.search), SizedBox(width: 8)],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsGeometry.only(
                        top: 16,
                        left: 8,
                        right: 8,
                      ),
                      child: Column(
                        spacing: 8,
                        children: List.generate(
                          15,
                          (index) => ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            tileColor: index == 1
                                ? Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh
                                : null,
                            title: Text('Table'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  leading: Icon(Icons.table_chart_outlined),
                  title: Text('Table'),
                  actions: [
                    IconButton(
                      onPressed: () => context
                          .read<DrawerStateModel>()
                          .showDrawer(const ColumnSettingsSideSheet()),
                      tooltip: 'Create Column',
                      icon: Icon(Icons.add_outlined),
                    ),
                    IconButton(
                      onPressed: () => context
                          .read<DrawerStateModel>()
                          .showDrawer(const NewRowSideSheet()),
                      tooltip: 'Add Row',
                      icon: Icon(Icons.playlist_add_outlined),
                    ),
                    IconButton(
                      onPressed: () => context
                          .read<DrawerStateModel>()
                          .showDrawer(const SourceSettingsSideSheet()),
                      tooltip: 'Settings',
                      icon: Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: LayoutBuilder(
                        builder:
                            (
                              BuildContext context,
                              BoxConstraints constraints,
                            ) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: DataTable(
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadiusGeometry.all(
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
                                              Text('Column'),
                                              Text(
                                                'Text',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelSmall,
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
                                        (colIdx) => DataCell(
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
            ),
          ),
        ],
      ),
    );
  }
}
