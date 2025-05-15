import 'package:flutter/material.dart';
import 'models/todo_item.dart';
import 'utils/shared_prefs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<TodoItem> _todoList = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void _loadTodoList() async {
    final list = await SharedPrefs.loadTodoList();
    setState(() {
      _todoList = list;
    });
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _todoList.add(TodoItem(title: text));
        _controller.clear();
      });
      SharedPrefs.saveTodoList(_todoList);
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _todoList[index].isDone = !_todoList[index].isDone;
    });
    SharedPrefs.saveTodoList(_todoList);
  }

  void _removeTodo(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xoá công việc này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
          TextButton(
            onPressed: () {
              setState(() {
                _todoList.removeAt(index);
              });
              SharedPrefs.saveTodoList(_todoList);
              Navigator.pop(context);
            },
            child: Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: InputDecoration(labelText: 'Thêm công việc'))),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _addTodo, child: Text('Thêm')),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (_, index) {
                  final item = _todoList[index];
                  return ListTile(
                    leading: Checkbox(value: item.isDone, onChanged: (_) => _toggleDone(index)),
                    title: Text(
                      item.title,
                      style: TextStyle(decoration: item.isDone ? TextDecoration.lineThrough : null),
                    ),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => _removeTodo(index)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
