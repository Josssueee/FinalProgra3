import 'package:flutter/material.dart';
import 'package:finalprogra/core/notification_service.dart';
import 'package:finalprogra/data/database_helper.dart';
import 'package:finalprogra/data/repositories/task_repository.dart';
import 'package:finalprogra/presentation/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializa todas las dependencias
  final databaseHelper = DatabaseHelper.instance;
  final taskRepository = TaskRepository(databaseHelper);
  final notificationService = NotificationService();

  // 2. Inicializa servicios
  await notificationService.initialize();

  // 3. Ejecuta la app pasando el repository
  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  // 4. Constructor que requiere el repository
  const MyApp({
    Key? key,
    required this.taskRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 5. Pasa el repository a la pantalla inicial
      home: TasksScreen(taskRepository: taskRepository),
    );
  }
}
