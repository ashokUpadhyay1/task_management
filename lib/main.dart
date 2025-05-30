import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management_app/notification_service.dart';
import 'controllers/task_controller.dart';
import 'models/task_model.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox('tasks');
  await Hive.openBox('preferences');

  await NotificationService().initialize();
  Get.put(TaskController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Management App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
