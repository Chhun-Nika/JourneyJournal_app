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
    final bool isReminderDue =
        item.reminderEnabled &&
        item.reminderTime != null &&
        DateTime.now().isAfter(item.reminderTime!);

    final textStyle = item.completed
        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          )
        : Theme.of(context).textTheme.bodyLarge;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[100],
      child: ListTile(
        onTap: onTap,
        title: Text(item.name, style: textStyle),
        subtitle: item.reminderEnabled && item.reminderTime != null
            ? Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('d MMM y • HH:mm').format(item.reminderTime!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isReminderDue ? Colors.red : Colors.grey[700],
                      fontWeight: isReminderDue
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              )
            : Text(
                "no reminder set",
                style: Theme.of(context).textTheme.bodySmall,
              ),
        trailing: Checkbox(
          value: item.completed,
          onChanged: (_) => onToggleCompleted?.call(),
          side: BorderSide(
            color: Colors.grey.shade400, // unchecked border
            width: 2,
          ),
          activeColor: AppTheme.primaryColor,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
