import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/theme/app_theme.dart';

class DayTileWidget extends StatelessWidget {
  final String dayCount; // "Day 1", "Day 2", etc.
  final DateTime dayDate; // date of the day
  final VoidCallback? onTap;

  const DayTileWidget({
    super.key,
    required this.dayCount,
    required this.dayDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat('d MMMM yyyy').format(dayDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.grey[100], // light background
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 3,
            ),
            title: Text(
              dayCount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            subtitle: Text(
              formattedDate,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
