import 'package:hive/hive.dart';

part 'sub_task.g.dart';

@HiveType(typeId: 2)
class Subtask extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  Subtask({required this.title, this.isCompleted = false});
}
