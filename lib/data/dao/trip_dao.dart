import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TripDao {
  static const tableName = "trips";
  final _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, Object?> tripData) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      tripData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Object?>?> getById(String tripId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
    if (results.isNotEmpty) return results.first;
    return null;
  }

  Future<List<Map<String, Object?>>> getByUserId(String userId) async {
    final db = await _dbHelper.database;
    return db.query(
      tableName,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> update(String tripId, Map<String, Object?> tripData) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      tripData,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
  }

  Future<void> delete(String tripId) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );
  }
}