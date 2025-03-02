import 'package:flutter/material.dart';
import 'package:todo_list_with_hive/db/todo_db.dart';
import 'package:todo_list_with_hive/widgets/todo_dialog.dart';
import 'package:todo_list_with_hive/widgets/todo_tile.dart';


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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildCreateTodoButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeData().primaryColor,
      title: Text(
        'TO-DO LIST (Hive)',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return _isLoading
        ? Center(child: const CircularProgressIndicator())
        : ValueListenableBuilder(
            valueListenable: TodoDb().todoBoxListenable!,
            builder: (context, box, child) {
              final todos = TodoDb().getAllTodos();
              return _buildListOfTodos(todos);
            },
          );
  }

  Widget _buildListOfTodos(dynamic todos) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20),
      itemCount: todos.length,
      separatorBuilder: (context, index) =>
          const Divider(thickness: 0.5, height: 0, indent: 40),
      itemBuilder: (context, index) {
        final todo = todos[index];
        final todoKey = todo[TodoDb.todoId];
        return TodoTile(
          contnet: todo[TodoDb.todoContent],
          time: todo[TodoDb.todoTime],
          isDone: todo[TodoDb.todoIsDone],
          onChanged: (value) => TodoDb().toggleTodoStatus(todoKey),
          deletePressed: (context) => TodoDb().deleteTodo(todoKey),
          updatePressed: (context) => _showUpdateTodoDialog(context, todoKey),
        );
      },
    );
  }

  Widget _buildCreateTodoButton() {
    return FloatingActionButton(
      onPressed: () => _showCreateTodoDialog(context),
      child: Icon(Icons.add),
    );
  }

  Future<void> _showCreateTodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        _todoController.clear();
        return TodoDialog(
          title: 'Create a Todo',
          subTitle: 'What do you want to do?',
          todoController: _todoController,
          onSave: () {
            if (_todoController.text.isNotEmpty) {
              TodoDb().addTodo(_todoController.text);
              Navigator.pop(context);
              _todoController.clear();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> _showUpdateTodoDialog(
      BuildContext context, dynamic todoKey) async {
    return showDialog(
      context: context,
      builder: (context) {
        final todo = TodoDb().getTodo(todoKey);
        _todoController.text = todo?[TodoDb.todoContent] ?? '';
        return TodoDialog(
          title: 'Update a Todo',
          subTitle: 'What do you want to do?',
          todoController: _todoController,
          onSave: () {
            if (_todoController.text.isNotEmpty) {
              TodoDb().updateTodo(todoKey, _todoController.text);
              Navigator.pop(context);
              _todoController.clear();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
