import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'study_garden.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plants(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            growth_stage INTEGER NOT NULL,
            minutes_accumulated INTEGER NOT NULL DEFAULT 0,
            is_active INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE focus_sessions(
            id TEXT PRIMARY KEY,
            plant_id TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL,
            sunlight_earned INTEGER NOT NULL,
            completed INTEGER NOT NULL,
            started_at TEXT NOT NULL,
            ended_at TEXT,
            notes TEXT,
            FOREIGN KEY (plant_id) REFERENCES plants(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE shop_items(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            price INTEGER NOT NULL,
            is_unlocked INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE app_stats(
            id INTEGER PRIMARY KEY,
            sunlight INTEGER NOT NULL
          )
        ''');

        await db.insert('app_stats', {'id': 1, 'sunlight': 0});

        await db.insert('shop_items', {
          'id': 'seed_1',
          'name': 'Sunflower Seed',
          'category': 'Seed',
          'price': 20,
          'is_unlocked': 0,
        });

        await db.insert('shop_items', {
          'id': 'seed_2',
          'name': 'Cactus Seed',
          'category': 'Seed',
          'price': 30,
          'is_unlocked': 0,
        });

        await db.insert('shop_items', {
          'id': 'pot_1',
          'name': 'Blue Pot',
          'category': 'Pot',
          'price': 15,
          'is_unlocked': 0,
        });
      },
    );
  }
}
