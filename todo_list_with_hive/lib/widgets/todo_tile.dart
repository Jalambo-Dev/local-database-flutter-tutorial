import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TodoTile extends StatelessWidget {
  final String contnet;
  final bool isDone;
  final Function(bool?)? onChanged;
  final void Function(BuildContext)? updatePressed;
  final void Function(BuildContext)? deletePressed;

  final DateTime time;

  const TodoTile({
    super.key,
    required this.contnet,
    required this.isDone,
    required this.time,
    this.onChanged,
    this.updatePressed,
    this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          // pined option
          SlidableAction(
            backgroundColor: Colors.amber,
            icon: CupertinoIcons.pin_fill,
            foregroundColor: Colors.white,
            onPressed: (context) {},
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // update option
          SlidableAction(
            backgroundColor: Colors.green,
            icon: Icons.edit,
            foregroundColor: Colors.white,
            onPressed: (context) => updatePressed!(context),
          ),

          // delete option
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) => deletePressed!(context),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          contnet,
          style: TextStyle(
            fontWeight: isDone ? FontWeight.normal : FontWeight.bold,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          DateFormat('h:mm a   yyyy-MM-dd').format(time),
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          textAlign: TextAlign.end,
        ),
        leading: Checkbox(
          value: isDone,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
