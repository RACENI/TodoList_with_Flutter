import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todolist/todo_provider.dart';
import 'package:todolist/TodoHome.dart';

import 'Todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) { // 웹에서 테스트하기 위한 코드
   await Hive.initFlutter();
  } else {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  Hive.registerAdapter(TodoAdapter());
  final todoBox = await Hive.openBox<Todo>('todos');

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(todoBox),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TodoHome(),
    );
  }
}