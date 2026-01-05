import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  static const tableName = "categories";
  final _dbHelper = DatabaseHelper.instance;

  // insert category use for seeding only
  Future<void> insert(Map<String, Object?> values) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  // Get categories by type
  Future<List<Map<String, Object?>>> getByType(
    String categoryType,
  ) async {
    final db = await _dbHelper.database;
    return await db.query(
      tableName,
      where: 'categoryType = ?',
      whereArgs: [categoryType],
      orderBy: 'name ASC',
    );
  }
}