class Todo {
  final int? id;
  final String todo;
  final int status;

  Todo({this.id, required this.todo, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'status': status,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      todo: map['todo'],
      status: map['status'],
    );
  }
}
