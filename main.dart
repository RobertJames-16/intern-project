import 'package:flutter/material.dart';

void main() {
  runApp(const TaskApp());
}

class Task {
  String title;
  String category;
  String priority;
  DateTime? dueDate;
  bool completed;

  Task({
    required this.title,
    this.category = "Academic",
    this.priority = "Medium",
    this.dueDate,
    this.completed = false,
  });
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple Task Manager",
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const TaskHome(),
    );
  }
}

class TaskHome extends StatefulWidget {
  const TaskHome({super.key});

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  final List<Task> _tasks = [];

  void _addTask() {
    showDialog(
      context: context,
      builder: (ctx) {
        final titleCtrl = TextEditingController();
        String category = "Academic";
        String priority = "Medium";
        DateTime? dueDate;

        return AlertDialog(
          title: const Text("Add Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                DropdownButton<String>(
                  value: category,
                  items: ["Academic", "Personal"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => category = v!),
                ),
                DropdownButton<String>(
                  value: priority,
                  items: ["High", "Medium", "Low"]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => priority = v!),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: DateTime(now.year + 1),
                    );
                    if (picked != null) {
                      setState(() => dueDate = picked);
                    }
                  },
                  child: Text(dueDate == null
                      ? "Pick Due Date"
                      : "Due: ${dueDate!.toLocal()}".split(" ")[0]),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.add(Task(
                    title: titleCtrl.text,
                    category: category,
                    priority: priority,
                    dueDate: dueDate,
                  ));
                });
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _toggle(Task t) {
    setState(() => t.completed = !t.completed);
  }

  void _delete(Task t) {
    setState(() => _tasks.remove(t));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Task Manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No tasks yet. Tap + to add."))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, i) {
                final t = _tasks[i];
                return Card(
                  child: ListTile(
                    title: Text(
                      t.title,
                      style: TextStyle(
                        decoration: t.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                        "${t.category} • ${t.priority}${t.dueDate != null ? " • Due ${t.dueDate!.toLocal().toString().split(" ")[0]}" : ""}"),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: Icon(
                              t.completed ? Icons.check_box : Icons.check_box_outline_blank),
                          onPressed: () => _toggle(t),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _delete(t),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

