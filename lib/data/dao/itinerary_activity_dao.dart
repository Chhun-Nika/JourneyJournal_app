import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ItineraryActivityDao {
  static const tableName = "itinerary_activities";
  final _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, Object> activityMap) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      activityMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Object?>?> getById(String activityId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'activityId = ?',
      whereArgs: [activityId],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<List<Map<String, Object?>>> getByTripId(String tripId) async {
    final db = await _dbHelper.database;
    return await db.query(
      tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'date, time',
    );
  }

  Future<void> update(Map<String, Object> activityMap, String activityId) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      activityMap,
      where: 'activityId = ?',
      whereArgs: [activityId],
    );
  }

  Future<void> delete(String activityId) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableName,
      where: 'activityId = ?',
      whereArgs: [activityId],
    );
  }
}