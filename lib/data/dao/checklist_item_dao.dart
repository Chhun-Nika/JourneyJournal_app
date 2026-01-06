import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ChecklistItemDao {
  static const String tableName = "checklist_items";
  final _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Object?>?> getById(String checklistItemId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'checklistItemId = ?',
      whereArgs: [checklistItemId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, Object?>>> getByTripId(String tripId) async {
    final db = await _dbHelper.database;
    return await db.query(
      tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'createdAt ASC',
    );
  }

  Future<void> update(
    String checklistItemId,
    Map<String, Object?> values,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      values,
      where: 'checklistItemId = ?',
      whereArgs: [checklistItemId],
    );
  }

  Future<void> delete(String checklistItemId) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableName,
      where: 'checklistItemId = ?',
      whereArgs: [checklistItemId],
    );
  }

}