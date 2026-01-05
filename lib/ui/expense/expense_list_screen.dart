import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/repository/category_repo.dart';
import '../../data/repository/expense_repo.dart';
import '../../model/category.dart';
import '../../model/expense.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/create_button.dart';
import 'expense_tile.dart';
import 'total_expense_card.dart';

class ExpenseListScreen extends StatefulWidget {
  final Trip trip;

  const ExpenseListScreen({super.key, required this.trip});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  bool isLoading = true;

  final ExpenseRepository expenseRepository = ExpenseRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  List<Category> expenseCategories = []; // store fetched categories
  Map<DateTime, List<Expense>> groupedExpenses = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load both expenses and categories
  Future<void> _loadData() async {
    try {
      // 1. Load categories of type expense
      expenseCategories = await categoryRepository.getCategoriesByType(CategoryType.expense);

      // 2. Load grouped expenses
      final grouped = await expenseRepository.getGroupedExpenses(widget.trip.tripId);

      if (!mounted) return;

      setState(() {
        groupedExpenses = grouped;
        widget.trip.expenses.clear();
        grouped.forEach((_, list) => widget.trip.expenses.addAll(list));
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading expenses or categories: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onCreatePressed() async {
    final newExpense = await context.push<Expense>(
      '/expenses/add',
      extra: {
        'tripId': widget.trip.tripId,
        'categories': expenseCategories, // pass categories to AddExpenseScreen
      },
    );

    if (newExpense != null) {
      final date = DateTime(newExpense.date.year, newExpense.date.month, newExpense.date.day);
      setState(() {
        groupedExpenses.putIfAbsent(date, () => []).add(newExpense);
        widget.trip.expenses.add(newExpense);
      });
    }
  }

  /// Helper to get category name from ID
  String getCategoryName(String categoryId) {
    final cat = expenseCategories.firstWhere(
      (c) => c.categoryId == categoryId,
      orElse: () => Category(
        categoryId: 'unknown',
        categoryType: CategoryType.expense,
        name: 'Unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return cat.name;
  }

  @override
  Widget build(BuildContext context) {
    final totalExpense = widget.trip.totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.trip.expenses.isEmpty
                ? const Center(child: Text('No expenses yet'))
                : Column(
                    children: [
                      TotalExpenseCard(totalAmount: totalExpense),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          children: groupedExpenses.entries.map((entry) {
                            final date = entry.key;
                            final expenses = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date header
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    DateFormat('d MMM y').format(date),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppTheme.primaryColor,
                                        ),
                                  ),
                                ),

                                // List of expenses for that date
                                ...expenses.map(
                                  (expense) => ExpenseTile(
                                    expense: expense,
                                    categoryName: getCategoryName(expense.categoryId),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: CreateButton(
        tooltip: 'Add New Expense',
        onPressed: _onCreatePressed,
      ),
    );
  }
}