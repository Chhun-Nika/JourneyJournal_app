import 'package:flutter/material.dart';
import '../../model/itinerary_activity.dart';
import '../shared/theme/app_theme.dart';

class AgendaTile extends StatelessWidget {
  final ItineraryActivity activity;
  final ValueChanged<bool?>? onChecked;

  const AgendaTile({
    super.key,
    required this.activity,
    this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isPastDue = activity.isPastDue;
    final isCompleted = activity.isCompleted;
    final hasLocation = activity.location?.isNotEmpty == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// LEFT TIMELINE
          Column(
            children: [
              Checkbox(
                shape: const CircleBorder(),
                value: isCompleted,
                onChanged: onChecked,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: WidgetStateBorderSide.resolveWith((states) {
                  if (!states.contains(WidgetState.selected)) {
                    return BorderSide(
                      color: Colors.grey.shade400,
                      width: 2,
                    );
                  }
                  return null;
                }),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          /// RIGHT CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22,),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// TITLE + LOCATION
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Activity name
                        Text(
                          activity.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),

                        /// Location row
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 14,
                              color: hasLocation
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hasLocation
                                    ? activity.location!
                                    : 'No location set',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: hasLocation
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade500,
                                  fontStyle: hasLocation
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// TIME + STATUS
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isPastDue
                            ? 'Overdue · ${activity.time.format(context)}'
                            : activity.time.format(context),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isPastDue ? Colors.red : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (activity.reminderEnabled)
                        const Icon(
                          Icons.notifications_active,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}