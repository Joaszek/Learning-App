import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/Word.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'word_database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT, english TEXT, korean TEXT, level TEXT, correctStreak INTEGER, incorrectStreak INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertWord(Word word) async {
    final db = await instance.database;

    await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Word>> getWordsByLevel(String level) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where: 'level = ?',
      whereArgs: [level],
    );

    return List.generate(maps.length, (i) {
      return Word.fromMap(maps[i]);
    });
  }
}
