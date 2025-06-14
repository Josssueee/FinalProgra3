import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../data/repositories/task_repository.dart';
import '../widgets/task_item.dart';
import 'add_edit_task_screen.dart';

class TasksScreen extends StatefulWidget {
  final TaskRepository taskRepository;

  const TasksScreen({super.key, required this.taskRepository});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = widget.taskRepository.getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tareas')),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas registradas'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: () => _deleteTask(task.id!),
                  onToggleComplete: (isCompleted) =>
                      _toggleTaskComplete(task, isCompleted),
                  onEdit: () => _navigateToEditTaskScreen(task),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteTask(int id) async {
    await widget.taskRepository.deleteTask(id);
    _refreshTasks();
  }

  Future<void> _toggleTaskComplete(Task task, bool isCompleted) async {
    final updatedTask = task.copyWith(isCompleted: isCompleted);
    await widget.taskRepository.updateTask(updatedTask);
    _refreshTasks();
  }

  void _navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          taskRepository: widget.taskRepository,
          onTaskSaved: _refreshTasks,
        ),
      ),
    );
  }

  void _navigateToEditTaskScreen(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          taskRepository: widget.taskRepository,
          onTaskSaved: _refreshTasks,
          task: task,
        ),
      ),
    );
  }
}
