import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/DetailPage.dart';
import 'package:todolist/todo_provider.dart';

class TodoHome extends StatelessWidget {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TodoHome({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context); // 상태 접근

    return Scaffold(
      appBar: AppBar(title: Text('To-Do 앱')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '할 일 입력',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '값을 입력하세요';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    provider.add(_controller.text);
                    _controller.clear();
                  }
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    provider.add(_controller.text);
                    _controller.clear();
                  }
                },
                child: Text('추가'),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.todos.length,
                  itemBuilder: (context, index) {
                    final todo = provider.todos[index];
                    return ListTile(
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) => provider.toggle(index),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => provider.remove(index),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailPage(index: index),
                            )
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
