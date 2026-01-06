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
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.tileVerticalMargin,
      ),
      height: AppTheme.tileHeight,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
      ),
      child: Material(
        color: Colors.transparent, // make Material transparent to show Container color
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
          onTap: onTap ?? () {}, // pass the callback
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.tileHorizontalPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tripName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
