import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/DetailPage.dart';
import 'package:todolist/todo_provider.dart';

import 'Todo.dart';

class TodoHome extends StatelessWidget {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

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
                    //provider.add(_controller.text);
                    provider.addWithDate(_controller.text, _selectedDate);
                    _controller.clear();
                    _selectedDate = null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                  );

                  if(pickedDate != null) {
                    _selectedDate = pickedDate;
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? '마감일 선택'
                      : '마감일: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //provider.add(_controller.text);
                    provider.addWithDate(_controller.text, _selectedDate);
                    _controller.clear();
                    _selectedDate = null;
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
                    final isOverdue = todo.dueDate != null && todo.dueDate!.isBefore(DateTime.now());
                    return ListTile(
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) => provider.toggle(index),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          color: isOverdue ? Colors.red : null,
                          decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: todo.dueDate != null
                      ? Text('마감일: ${todo.dueDate!.toLocal().toString().split(' ')[0]}')
                      : null,
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
