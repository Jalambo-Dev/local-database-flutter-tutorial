import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  Box? _todoBox;
  late TextEditingController _todoController;

  @override
  void initState() {
    super.initState();
    Hive.openBox('todos_box')
        .then((todoBox) => setState(() => _todoBox = todoBox));
    _todoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoInputDialog(context),
        child: Icon(Icons.add),
      ),
      body: _todoBox == null
          ? const CircularProgressIndicator()
          : ValueListenableBuilder(
              valueListenable: _todoBox!.listenable(),
              builder: (context, box, child) {
                final todoKeys = box.keys.toList();

                return SizedBox.expand(
                  child: ListView.builder(
                    itemCount: todoKeys.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          index.toString(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showTodoInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add a todo'),
        content: TextField(
          controller: _todoController,
          decoration: const InputDecoration(hintText: 'todo...'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _todoBox?.add({
                'content': _todoController.text,
                'time': DateTime.now().toIso8601String(),
                'isDone': false,
              });
              Navigator.pop(context);
              _todoController.clear();
            },
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
