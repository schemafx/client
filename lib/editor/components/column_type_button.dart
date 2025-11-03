import 'package:flutter/material.dart';
import 'package:schemafx/enum.dart';

class ColumnTypeButton extends StatefulWidget {
  final void Function(ColumnType) onSelected;

  const ColumnTypeButton({super.key, required this.onSelected});

  @override
  State<ColumnTypeButton> createState() => _ColumnTypeButtonState();
}

class _ColumnTypeButtonState extends State<ColumnTypeButton> {
  ColumnType type = ColumnType.text;
  final TextEditingController iconController = TextEditingController();

  void _setType(ColumnType newType) {
    setState(() {
      type = newType;
    });

    widget.onSelected(newType);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(switch (type) {
                ColumnType.number => Icons.numbers_outlined,
                ColumnType.percent => Icons.percent_outlined,
                ColumnType.date => Icons.calendar_today_outlined,
                _ => Icons.short_text_outlined,
              }),
              style: IconButton.styleFrom(
                fixedSize: const Size(48, 48),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            );
          },
      menuChildren: [
        const SizedBox(height: 5),
        MenuItemButton(
          leadingIcon: const Icon(Icons.short_text_outlined),
          onPressed: () => _setType(ColumnType.text),
          style: MenuItemButton.styleFrom(
            backgroundColor: type == ColumnType.text
                ? colorScheme.primaryContainer
                : null,
          ),
          child: Text('Text', style: textTheme.bodyLarge),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.numbers_outlined),
          onPressed: () => _setType(ColumnType.number),
          style: MenuItemButton.styleFrom(
            backgroundColor: type == ColumnType.number
                ? colorScheme.primaryContainer
                : null,
          ),
          child: Text('Number', style: textTheme.bodyLarge),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.percent_outlined),
          onPressed: () => _setType(ColumnType.percent),
          style: MenuItemButton.styleFrom(
            backgroundColor: type == ColumnType.percent
                ? colorScheme.primaryContainer
                : null,
          ),
          child: Text('Percent', style: textTheme.bodyLarge),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.calendar_today_outlined),
          onPressed: () => _setType(ColumnType.date),
          style: MenuItemButton.styleFrom(
            backgroundColor: type == ColumnType.date
                ? colorScheme.primaryContainer
                : null,
          ),
          child: Text('Date', style: textTheme.bodyLarge),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
