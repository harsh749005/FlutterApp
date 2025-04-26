import 'package:flutter/material.dart';
import 'todo_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ToDoHomePage(),
    );
  }
}

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({super.key});

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _todos = [];
  final ToDoDatabase _db = ToDoDatabase();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _db.getTasks();
    setState(() {
      _todos.clear();
      _todos.addAll(tasks);
    });
  }

  Future<void> _addTodo() async {
    if (_controller.text.isNotEmpty) {
      await _db.insertTask(_controller.text);
      _controller.clear();
      await _loadTasks();
    }
  }

  Future<void> _removeTodo(int index) async {
    await _db.deleteTask(index);
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTodo,
              child: const Text('Add ToDo'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeTodo(index),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
