import 'package:flutter/material.dart';
import 'package:todo_list_with_sqflite/models/todo_model.dart';
import 'package:todo_list_with_sqflite/services/database_service.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late TextEditingController _todoController;
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showTodosList(),
      floatingActionButton: _addTodoButton(),
    );
  }

  Widget _addTodoButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(context: context, builder: (_) => _showAddTodoDialog());
      },
      child: Icon(Icons.add),
    );
  }

  Widget _showAddTodoDialog() {
    return AlertDialog(
      title: Text('Add New Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          TextField(
            controller: _todoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: () {
                  if (_todoController.text.isEmpty) return;
                  _databaseService.addTodo(_todoController.text);
                  _todoController.clear();
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showTodosList() {
    return FutureBuilder(
      future: _databaseService.getTodos(),
      builder: (context, snapshot) => ListView.builder(
        itemCount: snapshot.data?.length ?? 0,
        itemBuilder: (context, index) {
          TodoModel todoModel = snapshot.data![index];
          return ListTile(
            title: Text(todoModel.content),
          );
        },
      ),
    );
  }
}
