import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_with_sqflite/todo.dart';

class DatabaseService {
  static Database? _db;
  final String _todosTableName = 'todos';
  final String _todosIdColumnName = 'id';
  final String _todosTodoColumnName = 'todo';
  final String _todosStatusColumnName = 'status';

  DatabaseService._constructor();

  static final DatabaseService _instance = DatabaseService._constructor();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "todos_db.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_todosTableName (
        $_todosIdColumnName INTEGER PRIMARY KEY, 
        $_todosTodoColumnName TEXT NOT NULL, 
        $_todosStatusColumnName INTEGER NOT NULL
      )
    ''');
  }

  Future<void> addTodo(Todo todo) async {
    final db = await database;
    await db.insert(_todosTableName, todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_todosTableName);
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }
}
