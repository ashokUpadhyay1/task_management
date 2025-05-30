import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final TaskController _taskController = Get.find();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
          actions: [
            IconButton(
              icon: Obx(() => Icon(
                    _taskController.isAscending.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                  )),
              onPressed: _taskController.toggleSorting,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await Get.to(() => AddTaskScreen());
                _taskController.loadTasks();
              },
            ),
          ],
        ),
        body: Obx(
          () => _taskController.tasks.isEmpty
              ? Center(child: Text("No tasks available"))
              : ListView.builder(
                  itemCount: _taskController.tasks.length,
                  itemBuilder: (context, index) {
                    final task = _taskController.tasks[index];
                    return Card(
                      color: task.isCompleted ? Colors.green : Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(task.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.description,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Due: ${DateFormat('yyyy-MM-dd').format(task.date)}",
                              style: TextStyle(
                                color: task.date.isBefore(DateTime.now())
                                    ? const Color.fromARGB(
                                        255, 198, 48, 35) // red
                                    : Colors.white, // blue
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Get.to(() => AddTaskScreen(task: task));
                              _taskController.loadTasks();
                            } else if (value == 'delete') {
                              _taskController.deleteTask(task.id!);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                                value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
