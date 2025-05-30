import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final DateTime? reminderDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.reminderDate,
    required this.date,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
    DateTime? reminderDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      reminderDate: reminderDate ?? this.reminderDate,
    );
  }
}
