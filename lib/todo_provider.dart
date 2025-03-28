
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;
  String _searchKeyword = '';

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword.toLowerCase();
    notifyListeners();
  }

  List<Todo> get todos {
    List<Todo> filtered = switch (_filter) {
      TodoFilter.done => _todos.where((t) => t.isDone).toList(),
      TodoFilter.undone => _todos.where((t) => !t.isDone).toList(),
      _ => List.from(_todos),
    };

    if(_searchKeyword.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchKeyword)
      ).toList();
    }

    return List.unmodifiable(filtered);
  }

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  TodoFilter get filter => _filter;

  Future<void> init() async {
    await _loadTodos();
  }

  void add(String title) {
    _todos.add(Todo(title: title));
    _saveTodos();
    notifyListeners();
  }

  void addWithDate(String title, [DateTime? dueDate]) {
    _todos.add(Todo(title: title, dueDate: dueDate));
    _saveTodos();
    notifyListeners();
  }

  void toggle(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    _saveTodos();
    notifyListeners();
  }

  void remove(int index) {
    _todos.removeAt(index);
    _saveTodos();
    notifyListeners();
  }

  void update(int index, String newTitle) {
    _todos[index].title = newTitle;
    _saveTodos();
    notifyListeners();
  }


  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _todos.map((e) => e.toJson()).toList();
    prefs.setString('todos', jsonEncode(jsonList));
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('todos');
    if(jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _todos.clear();
      _todos.addAll(decoded.map((e) => Todo.fromJson(e)));
      notifyListeners();
    }
  }
}

enum TodoFilter {all, done, undone}

class Todo {
  String title;
  bool isDone;
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