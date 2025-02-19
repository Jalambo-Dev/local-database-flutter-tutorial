import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_with_hive/db/todo_db.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late TextEditingController _todoController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();
    // Initialize the TodoDb and update state when ready
    TodoDb().init().then((_) => setState(() => _isLoading = false));
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIMPLE TODO LIST',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: TodoDb().todoBoxListenable!,
              builder: (context, box, child) {
                final todos = TodoDb().getAllTodos();
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    final todoKey = todo[TodoDb.todoId];
                    return Column(
                      children: [
                        Dismissible(
                          key: Key(todo[TodoDb.todoContent]),
                          background: Container(
                            padding: EdgeInsets.all(18),
                            color: Color(0xff144875),
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(Icons.delete_outline_rounded),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            // Keep reference for undo operation
                            final deletedTodo = Map<String, dynamic>.from(todo);
                            deletedTodo.remove(TodoDb.todoId);

                            // Delete the todo
                            await TodoDb().deleteTodo(todoKey);

                            // Show a snackbar with undo option
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Deleted "${todo[TodoDb.todoContent]}"',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () async => await TodoDb()
                                        .restoreTodo(todoKey, deletedTodo),
                                  ),
                                ),
                              );
                            }
                          },
                          child: ListTile(
                            // update todo
                            onLongPress: () async =>
                                _showUpdateTodoDialog(context, todoKey),

                            // checkbox todo
                            leading: Checkbox(
                              value: todo[TodoDb.todoIsDone],
                              onChanged: (value) async {
                                await TodoDb().toggleTodoStatus(todoKey);
                              },
                            ),

                            // title of todo
                            title: Text(
                              todo[TodoDb.todoContent],
                              style: TextStyle(
                                fontWeight: todo[TodoDb.todoIsDone]
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: todo[TodoDb.todoIsDone]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),

                            // time of todo
                            subtitle: Text(
                              DateFormat('hh:mm a - dd/MM/yy')
                                  .format(todo[TodoDb.todoTime]),
                            ),
                          ),
                        ),
                        Divider(height: 0, indent: 70, thickness: 0.5)
                      ],
                    );
                  },
                );
              },
            ),

      // floating action button to add new todo
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTodoDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /// Show a dialog to create a new todo.
  Future<void> _showCreateTodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        _todoController.clear();
        return AlertDialog(
          title: Text('Add a Todo'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('What do you want to do?'),
              TextField(
                controller: _todoController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  TodoDb().addTodo(_todoController.text);
                  Navigator.pop(context);
                  _todoController.clear();
                }
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to update a Todo.
  Future<void> _showUpdateTodoDialog(
      BuildContext context, dynamic todoKey) async {
    return showDialog(
      context: context,
      builder: (context) {
        final todo = TodoDb().getTodo(todoKey);
        _todoController.text = todo?[TodoDb.todoContent] ?? '';
        return AlertDialog(
          title: Text('Update a Todo'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('What do you want to do?'),
              TextField(
                controller: _todoController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  TodoDb().updateTodo(todoKey, _todoController.text);
                  Navigator.pop(context);
                  _todoController.clear();
                }
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
