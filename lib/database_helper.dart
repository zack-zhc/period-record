import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_1/period.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  final _newVersion = 4;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: _newVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE periods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        start INTEGER,
        end INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < _newVersion) {
      await db.execute(
        'ALTER TABLE periods ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  Future<int> insertPeriod(Period period) async {
    final db = await database;
    return await db.insert('periods', period.toMap());
  }

  Future<int> updatePeriod(Period period) async {
    final db = await database;
    return await db.update(
      'periods',
      period.toMap(),
      where: 'id = ?',
      whereArgs: [period.id],
    );
  }

  Future<int> deletePeriod(int id) async {
    final db = await database;
    return await db.delete('periods', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Period>> getPeriods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('periods');
    return List.generate(maps.length, (i) {
      return Period.fromMap(maps[i]);
    });
  }

  Future<Period?> getLatestPeriod() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'periods',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Period.fromMap(maps.first);
    }
    return null;
  }
}
