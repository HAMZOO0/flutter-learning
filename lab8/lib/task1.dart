import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodosProvider(),
      child: const MyApp(),
    ),
  );
}

class Todo {
  final String id;
  String title;
  bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  void toggleComplete() {
    isCompleted = !isCompleted;
  }
}

class TodosProvider extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos.where((todo) => !todo.isCompleted).toList();
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    _todos[index].toggleComplete();
    notifyListeners();
  }

  void updateTodo(String id, String newTitle) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    _todos[index].title = newTitle; // Now this works!
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (context) => const AddTodoDialog(),
                ),
          ),
        ],
      ),
      body: Consumer<TodosProvider>(
        builder: (context, provider, child) {
          if (provider.todos.isEmpty && provider.completedTodos.isEmpty) {
            return const Center(child: Text('No todos yet. Add one!'));
          }

          return ListView(
            children: [
              if (provider.todos.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Pending Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...provider.todos.map((todo) => TodoItem(todo: todo)).toList(),
              ],
              if (provider.completedTodos.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Completed Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...provider.completedTodos
                    .map((todo) => TodoItem(todo: todo))
                    .toList(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Todo'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Task',
            border: OutlineInputBorder(),
          ),
          validator:
              (value) => value?.isEmpty ?? true ? 'Please enter a task' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<TodosProvider>(context, listen: false).addTodo(
                Todo(id: DateTime.now().toString(), title: _controller.text),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Delete this task?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) {
        Provider.of<TodosProvider>(context, listen: false).removeTodo(todo.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (value) {
              Provider.of<TodosProvider>(
                context,
                listen: false,
              ).toggleTodo(todo.id);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTodo(context),
          ),
        ),
      ),
    );
  }

  void _editTodo(BuildContext context) {
    final controller = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Todo'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<TodosProvider>(
                    context,
                    listen: false,
                  ).updateTodo(todo.id, controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
