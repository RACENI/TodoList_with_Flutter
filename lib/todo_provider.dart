
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Todo.dart';

class TodoProvider extends ChangeNotifier {
  final Box<Todo> _box;
  TodoFilter _filter = TodoFilter.all;

//  final List<Todo> _todos = [];
  String _searchKeyword = '';

  TodoProvider(this._box);

  List<Todo> get todos {
    List<Todo> filtered = switch(_filter) {
      TodoFilter.done => _box.values.where((t) => t.isDone).toList(),
      TodoFilter.undone => _box.values.where((t) => !t.isDone).toList(),
      _ => _box.values.toList(),
    };
    if(_searchKeyword.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchKeyword)
      ).toList();
    }

    filtered.sort((a,b) {
      final aDate = a.dueDate ?? DateTime(2100);
      final bDate = b.dueDate ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });

    return filtered;
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword.toLowerCase();
    notifyListeners();
  }

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  TodoFilter get filter => _filter;

  // void add(String title) {
  //   _todos.add(Todo(title: title));
  //   _saveTodos();
  //   notifyListeners();
  // }

  void addWithDate(String title, [DateTime? dueDate]) {
    final todo = Todo(title: title, dueDate: dueDate);
    _box.add(todo);
    notifyListeners();
  }

  void toggle(int index) {
    final todo = _box.getAt(index);
    if(todo != null){
      todo.isDone = !todo.isDone;
      notifyListeners();
    }
  }

  void remove(int index) {
    _box.deleteAt(index);
    notifyListeners();
  }

  void update(int index, String newTitle) {
    final todo = _box.getAt(index);
    if (todo != null) {
      todo.title = newTitle;
      todo.save();
      notifyListeners();
    }
  }
}
