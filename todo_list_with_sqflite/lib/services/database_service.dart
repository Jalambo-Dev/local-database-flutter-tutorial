import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_with_sqflite/models/todo_model.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  final String _todosTableName = "todos";
  final String _todosIdColumnName = "id";
  final String _todosContentColumnName = "content";
  final String _todosStatusColumnName = 'status';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databseDirPath = await getDatabasesPath();
    final databasePath = join(databseDirPath, "todos_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_todosTableName (
          $_todosIdColumnName INTEGER PRIMARY KEY, 
          $_todosContentColumnName TEXT NOT NULL, 
          $_todosStatusColumnName INTEGER NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  void addTodo(String content) async {
    final db = await database;
    await db.insert(
      _todosTableName,
      {
        _todosContentColumnName: content,
        _todosStatusColumnName: 0,
      },
    );
  }

  Future<List<TodoModel>?> getTodos() async {
    final db = await database;
    final data = await db.query(_todosTableName);
    log(data.toString());
    List<TodoModel> todos = data
        .map(
          (e) => TodoModel(
            id: e['id'] as int,
            status: e['status'] as int,
            content: e['content'] as String,
          ),
        )
        .toList();

    return todos;
  }
}
