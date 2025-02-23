import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoDb {
  static const String todoBoxName = 'todos_box';
  static const String todoId = 'id';
  static const String todoContent = 'content';
  static const String todoTime = 'time';
  static const String todoIsDone = 'isDone';
  static const List<String> todoKeys = [
    todoId,
    todoContent,
    todoTime,
    todoIsDone
  ];

  // Singleton pattern
  static final TodoDb _instance = TodoDb._internal();
  factory TodoDb() => _instance;
  TodoDb._internal();

  Box? _todoBox;

  /// Initialize the database.
  Future<void> init() async {
    _todoBox = await Hive.openBox(todoBoxName);
  }

  /// Close the database.
  Future<void> close() async {
    await _todoBox?.close();
  }

  /// Get all todos.
  List<Map<String, dynamic>> getAllTodos() {
    final List<Map<String, dynamic>> todos = [];
    final List<dynamic> todoKeys = _todoBox?.keys.toList() ?? [];

    for (dynamic key in todoKeys) {
      final todo = _todoBox?.get(key);
      if (todo != null) {
        /// Creates a copy of the todo map to avoid modifying the original.
        final Map<String, dynamic> todoWithId = Map<String, dynamic>.from(todo);
        /// Adds the id of the to-do item to the copied map.
        todoWithId[todoId] = key; // The `key` is the unique identifier for the to-do item in the Hive box.
        /// Adds the modified map (now including the id) to the list of all to-do items.
        todos.add(todoWithId);
      }
    }
    return todos;
  }

  /// Add a new todo.
  ///
  /// Returns the key of the newly added todo.
  Future<dynamic> addTodo(String content) async {
    return await _todoBox?.add({
      todoContent: content,
      todoTime: DateTime.now(),
      todoIsDone: false,
    });
  }

  /// Update a todo by key.
  Future<void> updateTodo(dynamic key, String content) async {
    final todo = _todoBox?.get(key);
    if (todo != null) {
      await _todoBox?.put(key, {
        todoContent: content,
        todoTime: todo[todoTime],
        todoIsDone: todo[todoIsDone],
      });
    }
  }

  /// Toggle the isDone status of a todo.
  Future<void> toggleTodoStatus(dynamic key) async {
    final todo = _todoBox?.get(key);
    if (todo != null) {
      await _todoBox?.put(key, {
        todoContent: todo[todoContent],
        todoTime: todo[todoTime],
        todoIsDone: !todo[todoIsDone],
      });
    }
  }

  /// Delete a todo by key.
  Future<void> deleteTodo(dynamic key) async {
    await _todoBox?.delete(key);
  }

  /// Restore a deleted todo.
  Future<void> restoreTodo(dynamic key, Map<String, dynamic> todo) async {
    await _todoBox?.put(key, todo);
  }

  /// Get a todo by key.
  Map<String, dynamic>? getTodo(dynamic key) {
    return _todoBox?.get(key);
  }

  /// Get a todo by index.
  Map<String, dynamic>? getTodoAt(int index) {
    return _todoBox?.getAt(index);
  }

  /// Check if the database is initialized.
  bool get isInitialized => _todoBox != null;

  /// Get the todo box value listenable for reactive UI updates.
  ValueListenable<Box>? get todoBoxListenable => _todoBox?.listenable();
}
