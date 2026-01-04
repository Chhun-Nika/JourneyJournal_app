import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  static const tableName = "categories";
  final _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, Object?>>> getByUserAndType(
    String userId,
    int categoryType,
  ) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT *
      FROM $tableName
      WHERE categoryType = ?
        AND (userId = ? OR userId IS NULL)
      ORDER BY isDefault DESC, name ASC
      ''',
      [categoryType, userId],
    );
  }

  Future<void> update(
    String categoryId,
    Map<String, Object?> values,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      values,
      where: 'categoryId = ? AND isDefault = 0',
      whereArgs: [categoryId],
    );
  }

  Future<void> delete(String categoryId) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableName,
      where: 'categoryId = ? AND isDefault = 0',
      whereArgs: [categoryId],
    );
  }

}