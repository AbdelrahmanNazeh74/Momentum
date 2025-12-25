import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:momentum/core/constants/app_colors.dart';
import 'package:momentum/core/constants/app_icons.dart';
import 'package:momentum/core/localization/app_strings.dart';
import 'package:momentum/features/HomeScreen/data/models/sub_task.dart';
import 'package:momentum/features/HomeScreen/data/models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _subtaskController;

  @override
  void initState() {
    super.initState();
    _subtaskController = TextEditingController();
  }

  Future<void> _addSubtask() async {
    if (_subtaskController.text.isNotEmpty) {
      final subtask = Subtask(title: _subtaskController.text);
      final subtasksBox = Hive.box<Subtask>('subtasks');
      await subtasksBox.add(subtask);

      setState(() {
        widget.task.subtasks ??= HiveList(subtasksBox);
        widget.task.subtasks!.add(subtask);
        widget.task.save();
      });
      _subtaskController.clear();
    }
  }

  void _toggleSubtaskCompletion(Subtask subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
      widget.task.save();
    });
  }

  void _deleteSubtask(Subtask subtask) {
    setState(() {
      widget.task.subtasks!.remove(subtask);
      widget.task.save();
    });
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final completedSubtasks =
        widget.task.subtasks?.where((s) => s.isCompleted).length ?? 0;
    final totalSubtasks = widget.task.subtasks?.length ?? 0;
    final progress =
        totalSubtasks > 0 ? completedSubtasks / totalSubtasks : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    if (widget.task.description != null &&
                        widget.task.description!.isNotEmpty)
                      Text(
                        widget.task.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.subtasks,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (totalSubtasks > 0)
                  Text(
                    '$completedSubtasks/$totalSubtasks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
              ],
            ),
            if (totalSubtasks > 0)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                  minHeight: 6.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                itemCount: widget.task.subtasks?.length ?? 0,
                itemBuilder: (context, index) {
                  final subtask = widget.task.subtasks![index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (_) => _toggleSubtaskCompletion(subtask),
                        activeColor: AppColors.primaryColor,
                      ),
                      title: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: subtask.isCompleted
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(AppIcons.delete,
                            color: AppColors.errorColor),
                        onPressed: () => _deleteSubtask(subtask),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskController,
                      decoration: InputDecoration(
                        hintText: l10n.addSubtask,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _addSubtask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(16.r),
                    ),
                    child: const Icon(AppIcons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
