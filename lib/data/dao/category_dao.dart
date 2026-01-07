import 'package:journey_journal_app/data/database/database_helper.dart';

class CategoryDao {
  static const tableName = "categories";
  final _dbHelper = DatabaseHelper.instance;
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