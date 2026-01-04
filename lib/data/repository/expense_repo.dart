import '../../model/expense.dart';
import '../dao/expense_dao.dart';

class ExpenseRepository {
  final _expenseDao = ExpenseDao();

  // add new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseDao.insert(_toMap(expense));
  }

  // get expense by ID
  Future<Expense?> getExpense(String expenseId) async {
    final map = await _expenseDao.getById(expenseId);
    if (map == null) return null;
    return _fromMap(map);
  }

  // get all expenses for a trip
  Future<List<Expense>> getTripExpenses(String tripId) async {
    final maps = await _expenseDao.getByTripId(tripId);
    return maps.map((map) => _fromMap(map)).toList();
  }

  // Update and existing expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseDao.update(expense.expenseId, _toMap(expense));
  }

  // delete epxense
  Future<void> deleteExpense(String expenseId) async {
    await _expenseDao.delete(expenseId);
  }

  // convert from expense object to map, for storing back to db
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

  // from map to expense object, for ui usage
  Expense _fromMap(Map<String, dynamic> map) {
    return Expense(
      expenseId: map['expenseId'] as String,
      tripId: map['tripId'] as String,
      categoryId: map['categoryId'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}