import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/services/preference_service.dart';
import 'package:task_management_app/view_models/task_provider.dart';
import 'package:task_management_app/views/add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final tasks = ref.watch(taskProvider);
    final themeNotifier = ref.read(preferenceServiceProvider.notifier);
    final isDarkMode = ref.watch(preferenceServiceProvider) == 'dark';

    bool isAscending = ref.watch(sortingProvider);

    List sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) =>
        isAscending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              ref.read(sortingProvider.notifier).state = value == 'earliest';
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'earliest', child: Text('Sort: Earliest to Latest')),
              PopupMenuItem(
                  value: 'latest', child: Text('Sort: Latest to Earliest')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
              taskNotifier.loadTasks();
            },
          ),
        ],
      ),
      body: sortedTasks.isEmpty
          ? Center(child: Text("No tasks available"))
          : ListView.builder(
              itemCount: sortedTasks.length,
              itemBuilder: (context, index) {
                final task = sortedTasks[index];

                return Card(
                  color: task.isCompleted ? Colors.green : Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(task.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          style: TextStyle(color: Colors.black),
                        ),
                        if (task.date != null)
                          Text(
                            "Due: ${DateFormat('yyyy-MM-dd').format(task.date!)}",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 198, 48, 35),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          );
                          taskNotifier.loadTasks();
                        } else if (value == 'delete') {
                          taskNotifier.deleteTask(task.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
final sortingProvider = StateProvider<bool>((ref) => true);
