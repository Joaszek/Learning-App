import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/word.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    // Load and insert words right after the database initialization
    if (await isWordTableEmpty()) {
      _loadWordsAndInsert().then((_) {
        print('Initial data populated successfully');
      }).catchError((error) {
        print('Failed to populate initial data: $error');
      });
    }
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

  Future<void> _loadWordsAndInsert() async {
    final String contents =
        await rootBundle.loadString('assets/data/words.txt');
    final List<String> lines = contents.split('\n');
    final List<Word?> words = lines
        .map((line) {
          final parts = line.split(';');
          if (parts.length >= 2) {
            return Word(
              english: parts[0].trim(),
              korean: parts[1].trim(),
              level: 'no idea',
              correctStreak: 0,
              incorrectStreak: 0,
            );
          }
          return null;
        })
        .where((word) => word != null)
        .toList();

    await Future.wait(words.map((word) => insertWord(word!)));
  }

  Future<bool> isWordTableEmpty() async {
    // Define the path to your database
    String dbPath = join(await getDatabasesPath(), 'word_database.db');

    // Open the database
    final Database db = await openDatabase(dbPath);

    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) AS count FROM words');
    final int count = result[0]['count'];

    // Close the database to avoid memory leaks
    // our operations continues after this so we should close it later
    // await db.close();

    return count == 0; // Returns true if empty, false otherwise
  }
}
