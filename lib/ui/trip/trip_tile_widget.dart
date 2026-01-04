import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/theme/app_theme.dart';

class TripTileWidget extends StatelessWidget {
  final String tripName;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onTap;

  const TripTileWidget({
    super.key,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');
    final formattedDate =
        '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)} ${endDate.year}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent, // make Material transparent to show Container color
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ?? () {}, // pass the callback
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 3),
            title: Text(
              tripName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
            ),
            subtitle: Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 28,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}