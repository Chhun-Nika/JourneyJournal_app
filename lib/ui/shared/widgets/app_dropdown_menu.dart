import 'package:flutter/material.dart';

class AppDropdownMenu<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onSelected;
  final String? hintText;
  final bool enabled;

  const AppDropdownMenu({
    super.key,
    required this.label,
    required this.value,
    required this.entries,
    required this.onSelected,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseDecoration = theme.inputDecorationTheme;
    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      labelStyle: baseDecoration.labelStyle,
      contentPadding: baseDecoration.contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : null;
        return DropdownMenu<T>(
          enabled: enabled,
          width: width,
          label: Text(label),
          hintText: hintText,
          initialSelection: value,
          onSelected: onSelected,
          dropdownMenuEntries: entries,
          inputDecorationTheme: inputDecorationTheme,
        );
      },
    );
  }
}
