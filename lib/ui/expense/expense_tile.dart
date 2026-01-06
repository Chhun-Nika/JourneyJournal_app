import 'package:flutter/material.dart';
import 'package:journey_journal_app/model/expense.dart';
import '../shared/theme/app_theme.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final String categoryName; // Added
  final VoidCallback? onTap;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.categoryName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final note = expense.note?.trim();
    final subtitle = note == null || note.isEmpty
        ? categoryName
        : '$categoryName • $note';

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.tileVerticalMargin,
      ),
      height: AppTheme.tileHeight,
      child: Material(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
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
                        expense.title,
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
