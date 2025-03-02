import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  final String _todoTableName = 'Todos';
  final String _todoIdColumnName = 'id';
  final String _todoContentColumnName = 'content';
  final String _todoStatusColumnName = 'status';

  DatabaseService._();

  factory DatabaseService() {
    return _instance ?? DatabaseService._();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, 'todo_list_db.db');
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $_todoTableName (
                $_todoIdColumnName INTEGER PRIMARY KEY, 
                $_todoContentColumnName TEXT, 
                $_todoStatusColumnName INTEGER)
              ''');
      },
    );
    return db;
  }
}
