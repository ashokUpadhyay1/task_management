import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/task_database.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
   loadTasks();
   
  }

  Future<void> loadTasks() async {
    final tasks = await TaskDatabase.instance.getTasks();
    print("Loaded Tasks: ${tasks.length}");
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await TaskDatabase.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.deleteTask(id);
    await loadTasks();
  }
}

