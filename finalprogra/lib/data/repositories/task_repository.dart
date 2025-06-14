import '../database_helper.dart';
import '../../models/task.dart';

class TaskRepository {
  final DatabaseHelper _databaseHelper;

  TaskRepository(this._databaseHelper);

  Future<int> addTask(Task task) async {
    return await _databaseHelper.insertTask(task);
  }

  Future<List<Task>> getAllTasks() async {
    return await _databaseHelper.getAllTasks();
  }

  Future<int> updateTask(Task task) async {
    return await _databaseHelper.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _databaseHelper.deleteTask(id);
  }
}
