import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/notification_service.dart';
import '../../models/task.dart';
import '../../data/repositories/task_repository.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskRepository taskRepository;
  final VoidCallback onTaskSaved;
  final Task? task;

  const AddEditTaskScreen({
    super.key,
    required this.taskRepository,
    required this.onTaskSaved,
    this.task,
  });

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late bool _hasNotification;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _hasNotification = widget.task?.hasNotification ?? false;
    _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Agregar Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Fecha límite: '),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(DateFormat('dd/MM/yyyy').format(_dueDate)),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Notificación'),
                value: _hasNotification,
                onChanged: (value) {
                  setState(() {
                    _hasNotification = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final task = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        dueDate: _dueDate,
        hasNotification: _hasNotification,
      );

      if (widget.task == null) {
        await widget.taskRepository.addTask(task);
        _showNotification('Tarea creada', 'Has creado la tarea: $_title');
      } else {
        await widget.taskRepository.updateTask(task);
        _showNotification(
          'Tarea actualizada',
          'Has actualizado la tarea: $_title',
        );
      }

      if (_hasNotification) {
        await _notificationService.scheduleNotification(
          title: 'Recordatorio de tarea',
          body: 'Tienes pendiente: $_title',
          scheduledDate: _dueDate,
          id: task.id ?? 0,
        );
      }

      widget.onTaskSaved();
      Navigator.pop(context);
    }
  }

  Future<void> _showNotification(String title, String body) async {
    await _notificationService.showNotification(title: title, body: body);
  }
}
