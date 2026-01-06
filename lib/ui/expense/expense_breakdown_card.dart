import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../model/category.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';

class _BreakdownEntry {
  final String name;
  final double amount;
  final Color color;

  const _BreakdownEntry({
    required this.name,
    required this.amount,
    required this.color,
  });
}

const List<Color> _palette = [
  Color(0xFF89A4F1),
  Color(0xFF6C7AFA),
  Color(0xFF4CAF50),
  Color(0xFFFFB74D),
  Color(0xFFEF5350),
  Color(0xFF26A69A),
  Color(0xFFAB47BC),
];

class ExpenseBreakdownCard extends StatelessWidget {
  final Trip trip;
  final List<Category> categories;
  const ExpenseBreakdownCard({
    super.key,
    required this.trip,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries(trip.expenseTotalsByCategory);
    final total = entries.fold<double>(0, (sum, entry) => sum + entry.amount);
    final dataMap = {
      for (final entry in entries) entry.name: entry.amount,
    };
    final Map<String, double>chartData = dataMap.isEmpty ? {'No data': 1} : dataMap;
    final chartColors = entries.isEmpty
        ? [Colors.grey.shade300]
        : entries.map((entry) => entry.color).toList();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppTheme.tileHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppTheme.tileBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              dataMap: chartData,
              chartRadius: 150,
              colorList: chartColors,
              chartType: ChartType.disc,
              legendOptions: LegendOptions(
                showLegends: entries.isNotEmpty,
                legendPosition: LegendPosition.right,
                showLegendsInRow: false,
                legendTextStyle: textTheme.bodyMedium!,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: false,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Expense',
            style: textTheme.bodySmall?.copyWith(
              color: AppTheme.hintColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  

  List<_BreakdownEntry> _buildEntries(Map<String, double> totals) {
    final remainingTotals = Map<String, double>.from(totals);
    final List<_BreakdownEntry> entries = [];
    var colorIndex = 0;
    for (final category in categories) {
      final amount = remainingTotals.remove(category.categoryId);
      if (amount != null && amount > 0) {
        entries.add(
          _BreakdownEntry(
            name: category.name,
            amount: amount,
            color: _palette[colorIndex % _palette.length],
          ),
        );
        colorIndex++;
      }
    }

    if (remainingTotals.isNotEmpty) {
      final otherAmount = remainingTotals.values.fold<double>(
        0,
        (sum, value) => sum + value,
      );
      if (otherAmount > 0) {
        entries.add(
          _BreakdownEntry(
            name: 'Other',
            amount: otherAmount,
            color: _palette[colorIndex % _palette.length],
          ),
        );
      }
    }

    return entries;
  }

}
