import 'package:flutter/material.dart';

class TodoDialog extends StatelessWidget {
  final String title, subTitle;
  final TextEditingController todoController;
  final void Function()? onSave;
  final void Function()? onCancel;

  const TodoDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.todoController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subTitle),
          TextField(
            controller: todoController,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: onSave,
          child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: onCancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
