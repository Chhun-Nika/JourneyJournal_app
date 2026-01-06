import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static const tableName = 'users';
  final dbHelper = DatabaseHelper.instance;

  // insert new user
  Future<void> insert(Map<String, Object?> row) async {
    final db = await dbHelper.database;
    await db.insert(
      tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get user by email : this is use to get when login
  Future<Map<String, Object?>?> getByEmail(String email) async {
    final db = await dbHelper.database;
    final results = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // get user by id, use to verify password when knowing the email is existed in the database
  // will be used with login comparing input password with hashed one in db
  // and compare the password when user what to change password
  Future<Map<String, Object?>?> getById(String userId) async {
    final db = await dbHelper.database;
    final results = await db.query(
      tableName,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Get all users
  // Future<List<Map<String, Object?>>> getAll() async {
  //   final db = await dbHelper.database;
  //   return await db.query(tableName);
  // }

  // Update user
  Future<void> update(String userId, Map<String, Object?> row) async {
    final db = await dbHelper.database;
    await db.update(
      tableName,
      row,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Delete user
  Future<void> delete(String userId) async {
    final db = await dbHelper.database;
    await db.delete(
      tableName,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
