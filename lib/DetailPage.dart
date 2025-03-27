import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/main.dart';
import 'package:todolist/todo_provider.dart';

class DetailPage extends StatefulWidget {
  final int index;

  const DetailPage({required this.index, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = context.read<TodoProvider>().todos[widget.index];
    _controller = TextEditingController(text: todo.title);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final newTitle = _controller.text.trim();
    if(newTitle.isNotEmpty) {
      context.read<TodoProvider>().update(widget.index, newTitle);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('할 일 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '할 일 수정',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text("저장"))
          ],
        ),
      ),
    );
  }
}