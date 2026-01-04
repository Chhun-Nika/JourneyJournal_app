import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/expense_repo.dart';
import 'package:journey_journal_app/model/expense.dart';
import 'package:journey_journal_app/ui/expense/expense_tile.dart';
import 'package:journey_journal_app/ui/expense/total_expense_card.dart';
import 'package:journey_journal_app/ui/shared/create_button.dart';
import '../../data/seed/default_category.dart';


class ExpenseListScreen extends StatefulWidget {
  final String tripId;
  final ExpenseRepository expenseRepository;

  const ExpenseListScreen({
    super.key,
    required this.tripId,
    required this.expenseRepository,
  });

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    _expensesFuture = widget.expenseRepository.getTripExpenses(widget.tripId);
  }

  void _onCreatePressed() {
    // Navigate using GoRouter (adjust route as per your setup)
    context.push('/expenses/add', extra: {
      'tripId': 'some-valid-trip-id',
      'categories': defaultCategories,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Expense>>(
          future: _expensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final expenses = snapshot.data ?? [];

            if (expenses.isEmpty) {
              return const Center(child: Text('No expenses yet'));
            }

            final totalExpense = expenses.fold<double>(0, (sum, e) => sum + e.amount);

            return Column(
              children: [
                TotalExpenseCard(totalAmount: totalExpense),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ExpenseTile(expense: expense);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: CreateButton(
        tooltip: 'Add New Expense',
        onPressed: _onCreatePressed,
      ),
    );
  }
}
