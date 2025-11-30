import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:momentum/core/constants/app_icons.dart';
import 'package:momentum/features/HomeScreen/data/models/task_model.dart';
import 'package:momentum/core/localization/app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Task> _taskBox;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  void _toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
  }

  void _deleteTask(Task task) {
    final taskKey = task.key;
    final taskTitle = task.title;
    final taskIsCompleted = task.isCompleted;
    
    task.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.of(context).taskDeleted(taskTitle)),
        action: SnackBarAction(
          label: AppStrings.of(context).undo,
          onPressed: () {
            _taskBox.add(Task(
              title: taskTitle,
              isCompleted: taskIsCompleted,
            ));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: ValueListenableBuilder(
            valueListenable: _taskBox.listenable(),
            builder: (context, Box<Task> box, _) {
              List<Task> tasks = box.values.toList();
              
              if (_searchQuery.isNotEmpty) {
                tasks = tasks.where((task) => 
                  task.title.toLowerCase().contains(_searchQuery.toLowerCase())
                ).toList();
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appTitle,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 32.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.tasksCount(tasks.length),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: l10n.searchTasks,
                      prefixIcon: Icon(AppIcons.search, size: 24.r),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.w,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: tasks.isEmpty
                        ? const EmptyTasksState()
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Dismissible(
                                key: Key(task.key.toString()),
                                background: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Icon(
                                    AppIcons.delete,
                                    color: Colors.white,
                                    size: 28.r,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _deleteTask(task),
                                child: TaskItem(
                                  task: task,
                                  onTaskToggled: () => _toggleTaskCompletion(task),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTaskToggled;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTaskToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTaskToggled,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onTaskToggled,
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted
                            ? Colors.transparent
                            : Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: task.isCompleted
                        ? Icon(
                      AppIcons.check,
                      size: 18.r,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.isCompleted
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const AddTaskDialog({super.key, required this.onTaskAdded});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(l10n.addNewTask, style: TextStyle(fontSize: 20.sp)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: l10n.enterTaskTitle,
          hintStyle: TextStyle(fontSize: 16.sp),
          border: const OutlineInputBorder(),
        ),
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              final newTask = Task(title: _controller.text.trim());
              widget.onTaskAdded(newTask);
              Navigator.of(context).pop();
            }
          },
          child: Text(l10n.addTask, style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class EmptyTasksState extends StatelessWidget {
  const EmptyTasksState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.inboxOutlined,
            size: 64.r,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.noTasksYet,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.tapToAdd,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
