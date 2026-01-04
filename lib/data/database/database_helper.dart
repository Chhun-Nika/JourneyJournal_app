
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
  description TEXT,
  date TEXT NOT NULL,
  time TEXT NOT NULL,
  reminderEnabled INTEGER NOT NULL DEFAULT 0,
  reminderMinutesBefore INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (tripId) REFERENCES trips(tripId)
    ON DELETE CASCADE
);
''';

// when the category is deleted, the categoryId in expense table will be null instead of throwing errors
const String _createExpenseTable = '''
CREATE TABLE expenses (
  expenseId TEXT PRIMARY KEY,
  categoryId TEXT NOT NULL,
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
  categoryId TEXT NOT NULL,
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
  categoryType TEXT NOT NULL,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 1,
  userId TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE CASCADE
);
''';

class DatabaseHelper {
  // private constructor, make sure that it can only be used within this class / file
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  static const int _version = 1;
  static const String _dbName = "JourneyJournal.db";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final directory = await getApplicationSupportDirectory();
    print(directory);
    return openDatabase(join(await getDatabasesPath(), _dbName),
      version: _version,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
  }

  // enable relationship inside database
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createUserTable);
    await db.execute(_createTripTable);
    await db.execute(_createItineraryActivityTable);
    await db.execute(_createExpenseTable);
    await db.execute(_createCheckListItemTable);
    await db.execute(_createCategoriesTable);
  }

  

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<void> _onUpgrade(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  if (oldVersion < 2) {
    await db.execute('''
      ALTER TABLE trips ADD COLUMN destination TEXT NOT NULL DEFAULT ''
    ''');
  }
}
/// Delete the existing database entirely
  static Future<void> reset() async {
    // Close the current database
    await instance.close();

    // Get app directory
    final directory = await getApplicationSupportDirectory();

    // Database path
    final dbPath = join(directory.path, _dbName);

    // Delete the database file
    await deleteDatabase(dbPath);

    print('Database reset: $dbPath deleted');
  }


}
