
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  List<Todo> get todos {
    switch(_filter) {
      case TodoFilter.done:
        return _todos.where((t) => t.isDone).toList();
      case TodoFilter.undone:
        return _todos.where((t) => !t.isDone).toList();
      case TodoFilter all:
      default:
        return List.unmodifiable(_todos);
    }
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

  Todo({required this.title, this.isDone=false});

  Map<String, dynamic> toJson() => {
    'title' : title,
    'isDone' : isDone,
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json['title'],
    isDone: json['isDone'],
  );
}