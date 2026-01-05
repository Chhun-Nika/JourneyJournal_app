import '../../model/expense.dart';
import '../dao/expense_dao.dart';

class ExpenseRepository {
  final _expenseDao = ExpenseDao();

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseDao.insert(_toMap(expense));
  }

  // Get expense by ID
  Future<Expense?> getExpense(String expenseId) async {
    final map = await _expenseDao.getById(expenseId);
    if (map == null) return null;
    return _fromMap(map);
  }

  // Get all expenses for a trip
  Future<List<Expense>> getTripExpenses(String tripId) async {
    final maps = await _expenseDao.getByTripId(tripId);
    return maps.map((map) => _fromMap(map)).toList();
  }

  // Group expenses by date
  Future<Map<DateTime, List<Expense>>> getGroupedExpenses(String tripId) async {
    final expenses = await getTripExpenses(tripId);

    final Map<DateTime, List<Expense>> grouped = {};

    for (var expense in expenses) {
      // Use only year, month, day for grouping
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      grouped.putIfAbsent(date, () => []).add(expense);
    }

    return grouped;
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseDao.update(expense.expenseId, _toMap(expense));
  }

  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    await _expenseDao.delete(expenseId);
  }

  // Map conversion for DB
  Map<String, Object?> _toMap(Expense expense) {
    return {
      'expenseId': expense.expenseId,
      'tripId': expense.tripId,
      'categoryId': expense.categoryId,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'note': expense.note,
      'createdAt': expense.createdAt.toIso8601String(),
      'updatedAt': expense.updatedAt.toIso8601String(),
    };
  }

  // Map -> Expense object
  Expense _fromMap(Map<String, dynamic> map) {
    return Expense(
      expenseId: map['expenseId'] as String,
      tripId: map['tripId'] as String,
      categoryId: map['categoryId'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}