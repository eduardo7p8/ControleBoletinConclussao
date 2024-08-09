import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'school.db');

    return await openDatabase(
      dbPath,
      version: 2, // Atualize a versão do banco de dados
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE disciplines (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          isSemester INTEGER,
          createdAt TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE grades (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          disciplineId INTEGER,
          grade REAL,
          semester INTEGER,
          createdAt TEXT,
          year INTEGER,
          FOREIGN KEY(disciplineId) REFERENCES disciplines(id)
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE grades ADD COLUMN year INTEGER');
        }
      },
    );
  }

  Future<int> insertDiscipline(Map<String, dynamic> discipline) async {
    final db = await database;
    return await db.insert('disciplines', discipline);
  }

  Future<int> insertGrade(Map<String, dynamic> grade) async {
    final db = await database;
    return await db.insert('grades', grade);
  }

  Future<List<Map<String, dynamic>>> getDisciplines() async {
    final db = await database;
    return await db.query('disciplines');
  }

  Future<List<Map<String, dynamic>>> getGrades(int disciplineId) async {
    final db = await database;
    return await db.query('grades', where: 'disciplineId = ?', whereArgs: [disciplineId]);
  }

  Future<void> deleteDiscipline(int disciplineId) async {
    final db = await database;

    //
    await db.delete('grades', where: 'disciplineId = ?', whereArgs: [disciplineId]);

    //
    await db.delete('disciplines', where: 'id = ?', whereArgs: [disciplineId]);
  }

  Future<void> deleteGradesByDisciplineId(int disciplineId) async {
    final db = await database;
    await db.delete('grades', where: 'disciplineId = ?', whereArgs: [disciplineId]);
  }
}
