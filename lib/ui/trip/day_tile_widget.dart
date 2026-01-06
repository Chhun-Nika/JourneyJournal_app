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

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.tileVerticalMargin,
      ),
      height: AppTheme.tileHeight,
      child: Material(
        color: Colors.grey[100], // light background
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
          onTap: onTap,
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
                        dayCount,
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
