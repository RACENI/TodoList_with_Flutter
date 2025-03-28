import 'package:hive/hive.dart';

//dart run build_runner build
part 'Todo.g.dart'; // ✅ 반드시 있어야 build_runner가 인식함

enum TodoFilter {all, done, undone}

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  DateTime? dueDate;

  Todo({required this.title, this.isDone=false, this.dueDate});

  Map<String, dynamic> toJson() => {
    'title' : title,
    'isDone' : isDone,
    'dueDate' : dueDate?.toIso8601String(),
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json['title'],
    isDone: json['isDone'],
    dueDate: json['dueDate'] != null
        ? DateTime.parse(json['dueDate'])
        : null,
  );
}