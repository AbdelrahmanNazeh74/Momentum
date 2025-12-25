import 'package:hive/hive.dart';
import 'package:momentum/features/HomeScreen/data/models/priority.dart';
import 'package:momentum/features/HomeScreen/data/models/sub_task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  Priority priority;

  @HiveField(6)
  String? category;

  @HiveField(7)
  HiveList<Subtask>? subtasks;

  @HiveField(8)
  int? order;

  Task({
    required this.title,
    String? id,
    this.isCompleted = false,
    this.description,
    this.dueDate,
    this.priority = Priority.medium,
    this.category,
    this.subtasks,
    this.order,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    String? category,
    HiveList<Subtask>? subtasks,
    int? order,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      subtasks: subtasks ?? this.subtasks,
      order: order ?? this.order,
    );
  }
}
