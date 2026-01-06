import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/checklist_item.dart';
import '../shared/theme/app_theme.dart';

class ChecklistItemTile extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback? onToggleCompleted;
  final VoidCallback? onTap;

  const ChecklistItemTile({
    super.key,
    required this.item,
    this.onToggleCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isReminderDue =
        !item.completed &&
        item.reminderEnabled &&
        item.reminderTime != null &&
        !now.isBefore(item.reminderTime!);

    final textStyle = item.completed
        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          )
        : Theme.of(context).textTheme.bodyLarge;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.tileVerticalMargin,
      ),
      height: AppTheme.tileHeight,
      child: Material(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
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
                        item.name,
                        style: textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (item.reminderEnabled && item.reminderTime != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.notifications_active_outlined,
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                DateFormat('d MMM y • HH:mm')
                                    .format(item.reminderTime!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isReminderDue
                                          ? Colors.red
                                          : Colors.grey[700],
                                      fontWeight: isReminderDue
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "No reminder set",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                Checkbox(
                  value: item.completed,
                  onChanged: (_) => onToggleCompleted?.call(),
                  side: BorderSide(
                    color: Colors.grey.shade400, // unchecked border
                    width: 2,
                  ),
                  activeColor: AppTheme.primaryColor,
                  shape: const CircleBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
