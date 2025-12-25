import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:momentum/core/constants/app_colors.dart';
import 'package:momentum/core/constants/app_icons.dart';
import 'package:momentum/features/HomeScreen/data/models/priority.dart';
import 'package:momentum/features/HomeScreen/data/models/task_model.dart';
import 'package:momentum/core/localization/app_strings.dart';
import 'package:momentum/features/HomeScreen/view/task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _kFilterAll = 'all';
  static const String _kFilterToday = 'today';
  static const String _kFilterUpcoming = 'upcoming';

  static const String _kSortByNone = 'none';
  static const String _kSortByDate = 'date';
  static const String _kSortByPriority = 'priority';
  static const String _kSortByCategory = 'category';

  late Box<Task> _taskBox;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filter = _kFilterAll;
  String _sortOrder = _kSortByNone;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      task.save();
    });
  }

  void _deleteTask(Task task) {
    final taskKey = task.key;
    final taskTitle = task.title;
    final taskIsCompleted = task.isCompleted;
    final taskDescription = task.description;
    final taskDueDate = task.dueDate;
    final taskPriority = task.priority;
    final taskCategory = task.category;
    final taskSubtasks = task.subtasks;
    final taskOrder = task.order;

    task.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.of(context).taskDeleted(taskTitle)),
        action: SnackBarAction(
          label: AppStrings.of(context).undo,
          onPressed: () {
            final undoneTask = Task(
              title: taskTitle,
              isCompleted: taskIsCompleted,
              description: taskDescription,
              dueDate: taskDueDate,
              priority: taskPriority,
              category: taskCategory,
              subtasks: taskSubtasks,
              order: taskOrder,
            );
            _taskBox.add(undoneTask);
          },
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final List<Task> tasks = _taskBox.values.toList();
      final Task task = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, task);

      for (int i = 0; i < tasks.length; i++) {
        tasks[i].order = i;
        tasks[i].save();
      }
    });
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

              // Filtering
              if (_filter == _kFilterToday) {
                tasks = tasks.where((task) {
                  return task.dueDate != null &&
                      task.dueDate!.year == DateTime.now().year &&
                      task.dueDate!.month == DateTime.now().month &&
                      task.dueDate!.day == DateTime.now().day;
                }).toList();
              } else if (_filter == _kFilterUpcoming) {
                tasks = tasks.where((task) {
                  return task.dueDate != null &&
                      task.dueDate!.isAfter(DateTime.now());
                }).toList();
              }

              // Sorting
              if (_sortOrder == _kSortByDate) {
                tasks.sort((a, b) => (a.dueDate ?? DateTime(0))
                    .compareTo(b.dueDate ?? DateTime(0)));
              } else if (_sortOrder == _kSortByPriority) {
                tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
              } else if (_sortOrder == _kSortByCategory) {
                tasks.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
              } else {
                tasks.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
              }

              if (_searchQuery.isNotEmpty) {
                tasks = tasks
                    .where((task) =>
                        task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                                width: 2,
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
                      ),
                      SizedBox(width: 8.w),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            _sortOrder = value;
                          });
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: _kSortByNone,
                            child: Text('${l10n.sortBy} ${l10n.sortByNone}'),
                          ),
                          PopupMenuItem<String>(
                            value: _kSortByDate,
                            child: Text('${l10n.sortBy} ${l10n.sortByDate}'),
                          ),
                          PopupMenuItem<String>(
                            value: _kSortByPriority,
                            child: Text('${l10n.sortBy} ${l10n.sortByPriority}'),
                          ),
                          PopupMenuItem<String>(
                            value: _kSortByCategory,
                            child: Text('${l10n.sortBy} ${l10n.sortByCategory}'),
                          ),
                        ],
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text(l10n.filterAll),
                        selected: _filter == _kFilterAll,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filter = _kFilterAll;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 8.w),
                      ChoiceChip(
                        label: Text(l10n.filterToday),
                        selected: _filter == _kFilterToday,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filter = _kFilterToday;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 8.w),
                      ChoiceChip(
                        label: Text(l10n.filterUpcoming),
                        selected: _filter == _kFilterUpcoming,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filter = _kFilterUpcoming;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: tasks.isEmpty
                        ? const EmptyTasksState()
                        : ReorderableListView.builder(
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
                                  child: const Icon(
                                    AppIcons.delete,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _deleteTask(task),
                                child: TaskItem(
                                  task: task,
                                  onTaskToggled: () => _toggleTaskCompletion(task),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TaskDetailsScreen(task: task),
                                      ),
                                    ).then((_) => setState(() {}));
                                  },
                                ),
                              );
                            },
                            onReorder: _onReorder,
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
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTaskToggled,
    required this.onTap,
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
          onTap: onTap,
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
                          ? AppColors.primaryColor
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
                        ? const Icon(
                            AppIcons.check,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                      if (task.description != null && task.description!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            task.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      if (task.dueDate != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            DateFormat.yMMMd().format(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                if (task.category != null && task.category!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      task.category!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(context, task.priority),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    task.priority.toString().split('.').last[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final int taskCount;

  const AddTaskDialog({
    super.key,
    required this.onTaskAdded,
    required this.taskCount,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? _dueDate;
  Priority _priority = Priority.medium;

  String _getTranslatedPriority(Priority priority, AppStrings l10n) {
    switch (priority) {
      case Priority.high:
        return l10n.priorityHigh;
      case Priority.medium:
        return l10n.priorityMedium;
      case Priority.low:
        return l10n.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(l10n.addNewTask, style: TextStyle(fontSize: 20.sp)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: l10n.enterTaskTitle,
                hintStyle: TextStyle(fontSize: 16.sp),
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descriptionController,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: l10n.description,
                hintStyle: TextStyle(fontSize: 16.sp),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _categoryController,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: l10n.category,
                hintStyle: TextStyle(fontSize: 16.sp),
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                    icon: const Icon(AppIcons.calendar, size: 24),
                    label: Text(_dueDate == null
                        ? l10n.dueDate
                        : DateFormat.yMMMd().format(_dueDate!)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<Priority>(
              value: _priority,
              items: Priority.values
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(_getTranslatedPriority(priority, l10n)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.priority,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              final newTask = Task(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                category: _categoryController.text.trim(),
                dueDate: _dueDate,
                priority: _priority,
                order: widget.taskCount, // Assign the new task to the end of the list
              );
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
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
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
          const Icon(
            AppIcons.inboxOutlined,
            size: 64,
            color: AppColors.secondaryColor,
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
