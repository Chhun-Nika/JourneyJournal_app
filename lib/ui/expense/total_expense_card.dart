import 'package:flutter/material.dart';

class TotalExpenseCard extends StatelessWidget {
  final double totalAmount;

  const TotalExpenseCard({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Expense',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
