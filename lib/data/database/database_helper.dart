import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../seed/default_category.dart';

const String _createUserTable = '''
CREATE TABLE users (
  userId TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
);
''';

const String _createTripTable = '''
CREATE TABLE trips (
  tripId TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  title TEXT NOT NULL,
  destination TEXT NOT NULL,
  startDate TEXT NOT NULL,
  endDate TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE CASCADE
);
''';

const String _createItineraryActivityTable = '''
CREATE TABLE itinerary_activities (
  activityId TEXT PRIMARY KEY,
  tripId TEXT NOT NULL,
  name TEXT NOT NULL,
  location TEXT,
  description TEXT,
  date TEXT NOT NULL,
  time TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  reminderEnabled INTEGER NOT NULL DEFAULT 0,
  reminderMinutesBefore INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (tripId) REFERENCES trips(tripId)
    ON DELETE CASCADE
);
''';

const String _createExpenseTable = '''
CREATE TABLE expenses (
  expenseId TEXT PRIMARY KEY,
  categoryId TEXT,
  tripId TEXT NOT NULL,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  date TEXT NOT NULL,
  note TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (tripId) REFERENCES trips(tripId)
    ON DELETE CASCADE,
  FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
    ON DELETE SET NULL
);
''';

const String _createCheckListItemTable = '''
CREATE TABLE checklist_items (
  checklistItemId TEXT PRIMARY KEY,
  categoryId TEXT,
  tripId TEXT NOT NULL,
  name TEXT NOT NULL,
  completed INTEGER NOT NULL DEFAULT 0,
  reminderEnabled INTEGER NOT NULL DEFAULT 0,
  reminderTime TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (tripId) REFERENCES trips(tripId)
    ON DELETE CASCADE,
  FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
    ON DELETE SET NULL
);
''';

const String _createCategoriesTable = '''
CREATE TABLE categories (
  categoryId TEXT PRIMARY KEY,
  categoryType INTEGER NOT NULL,
  name TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
);
''';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  static const int _version = 1;
  static const String _dbName = "JourneyJournal.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create all tables
    await db.execute(_createUserTable);
    await db.execute(_createTripTable);
    await db.execute(_createItineraryActivityTable);
    await db.execute(_createExpenseTable);
    await db.execute(_createCheckListItemTable);
    await db.execute(_createCategoriesTable);

    // Seed default categories
    final now = DateTime.now();
    for (final cat in defaultCategories) {
      await db.insert(
        'categories',
        {
        'categoryId': cat.categoryId,
        'categoryType': cat.categoryType.index,
        'name': cat.name,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    print('Database created and default categories seeded.');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Delete the existing database entirely
  static Future<void> reset() async {
    await instance.close();
    final dbPath = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(dbPath);
    print('Database reset: $dbPath deleted');
  }
}
