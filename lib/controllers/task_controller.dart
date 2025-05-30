import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_management_app/notification_service.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isAscending = true.obs;
  final Box taskBox = Hive.box('tasks');
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    final taskList = taskBox.values.map((item) => item as Task).toList();
    tasks.assignAll(taskList);
    sortTasks();
  }

  Future<void> addTask(Task task) async {
    final hasPermission =
        await _notificationService.requestNotificationPermission();

    if (!hasPermission) {
      Get.snackbar(
        'Permission Required',
        'Please enable notifications to get reminders',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final id = await taskBox.add(task);
    final updatedTask = task.copyWith(id: id);
    await taskBox.put(id, updatedTask);

    if (task.reminderDate != null &&
        task.reminderDate!.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: id +
            1000,
        title: 'Reminder: ${task.title}',
        body: task.description,
        dueDate: task.reminderDate!,
      );
    } else if (task.date.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: id,
        title: 'Task Reminder: ${task.title}',
        body: task.description,
        dueDate: task.date,
      );
    }
    loadTasks();
  }

  void updateTask(Task task) async {
    if (task.id != null) {
      await _notificationService.cancelNotification(task.id!);
      await _notificationService.cancelNotification(task.id! + 1000);
      taskBox.put(task.id, task);
      if (task.date.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(
          id: task.id!,
          title: 'Task Reminder: ${task.title}',
          body: task.description,
          dueDate: task.date,
        );
      }
      if (task.reminderDate != null &&
          task.reminderDate!.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(
          id: task.id! + 1000,
          title: 'Reminder: ${task.title}',
          body: task.description,
          dueDate: task.reminderDate!,
        );
      }
      loadTasks();
    }
  }

  void deleteTask(int id) async {
    await _notificationService.cancelNotification(id);
    taskBox.delete(id);
    loadTasks();
  }

  void toggleSorting() {
    isAscending.value = !isAscending.value;
    sortTasks();
  }

  void sortTasks() {
    tasks.sort((a, b) => isAscending.value
        ? a.date.compareTo(b.date)
        : b.date.compareTo(a.date));
  }
}
