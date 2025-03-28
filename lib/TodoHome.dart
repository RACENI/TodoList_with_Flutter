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
    final todos = context.watch<TodoProvider>().todos;

    return Scaffold(
      appBar: AppBar(title: Text('To-Do 앱')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                      value: provider.filter,
                      onChanged: (value) {
                        if(value != null) {
                          provider.setFilter(value);
                        }
                      },
                      items: [
                        DropdownMenuItem(value: TodoFilter.all, child: Text('전체')),
                        DropdownMenuItem(value: TodoFilter.undone, child: Text('미완료')),
                        DropdownMenuItem(value: TodoFilter.done, child: Text('완료')),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex: 7,
                    child: TextField(
                        decoration: InputDecoration(
                          labelText: '검색',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          provider.setSearchKeyword(value);
                        },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
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
