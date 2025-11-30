import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/core/constants/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _searchController = TextEditingController();
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(_tasks);
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onTaskAdded: (newTask) {
          setState(() {
            _tasks.add(newTask);
            _filteredTasks.add(newTask);
          });
        },
      ),
    );
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _filterTasks(String query) {
    setState(() {
      _filteredTasks = _tasks
          .where((task) =>
          task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
      _filteredTasks.remove(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} has been deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.add(task);
              _filteredTasks.add(task);
            });
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
    int completedCount = _tasks.where((task) => task.isCompleted).length;
    int pendingCount = _tasks.length - completedCount;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Momentum',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${_tasks.length} task${_tasks.length != 1 ? 's' : ''}',
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
                onChanged: _filterTasks,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
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
                child: _filteredTasks.isEmpty
                    ? const EmptyTasksState()
                    : ListView.builder(
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    return Dismissible(
                      key: Key(task.id),
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(AppIcons.add, size: 24.r),
      ),
    );
  }
}

class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.title})
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        isCompleted = false;

  Task copyWith({bool? isCompleted}) {
    return Task(
      title: title,
    )..isCompleted = isCompleted ?? this.isCompleted;
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

// The rest of the supporting classes remain the same
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text('Add New Task', style: TextStyle(fontSize: 20.sp)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: 'Enter task title',
          hintStyle: TextStyle(fontSize: 16.sp),
          border: const OutlineInputBorder(),
        ),
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              final newTask = Task(title: _controller.text.trim());
              widget.onTaskAdded(newTask);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add Task', style: TextStyle(fontSize: 14.sp)),
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
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to add your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}