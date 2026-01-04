import '../database/database_helper.dart';

class ExpenseDao {
  static const String tableName = 'expenses';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insert a row into the expenses table
  Future<int> insert(Map<String, Object?> row) async {
    final db = await _dbHelper.database;
    return await db.insert(tableName, row);
  }

  // Get a single expense by its ID
  Future<Map<String, Object?>?> getById(String expenseId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'expenseId = ?',
      whereArgs: [expenseId],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // Get all expenses for a given trip
  Future<List<Map<String, Object?>>> getByTripId(String tripId) async {
    final db = await _dbHelper.database;
    return await db.query(
      tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
  }

  // Update an expense by its ID
  Future<int> update(String expenseId, Map<String, Object?> row) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      row,
      where: 'expenseId = ?',
      whereArgs: [expenseId],
    );
  }

  // Delete an expense by its ID
  Future<int> delete(String expenseId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableName,
      where: 'expenseId = ?',
      whereArgs: [expenseId],
    );
  }
}