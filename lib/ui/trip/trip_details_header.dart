import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';
import '../../model/trip.dart';

class TripDetailsHeader extends StatelessWidget {
  final Trip trip;

  const TripDetailsHeader({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');
    final dateRange =
        '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}';
    final textTheme = Theme.of(context).textTheme;
    return DottedBorder(
      options: const RectDottedBorderOptions(
        color: AppTheme.primaryColor,
        strokeWidth: 1.5,
        dashPattern: [7, 3],

        // borderPadding: EdgeInsets.all(0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Destination row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Destination',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(trip.destination, style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dates',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(dateRange, style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 10),

            // Total days row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Days',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text('${trip.totalDays} Days', style: textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
