import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:momentum/core/constants/app_icons.dart';

import '../../HomeScreen/data/models/task_model.dart';
import '../../HomeScreen/view/home_screen.dart';
import '../../SettingsScreen/view/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Start with Home tab selected

  final List<Widget> _screens = const [
    HomeScreen(),
    SettingsScreen(),
  ];

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onTaskAdded: (newTask) {
          final taskBox = Hive.box<Task>('tasks');
          taskBox.add(newTask);
          // Optional: Navigate back to home after adding task if desired
          // setState(() => _currentIndex = 0);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      floatingActionButton: Container(
        height: 65.r,
        width: 65.r,
        margin: EdgeInsets.only(top: 30.h), // Adjusted margin to float correctly above the bar
        child: FloatingActionButton(
          onPressed: _addTask, // Call _addTask regardless of current index
          elevation: 4,
          backgroundColor: const Color(0xFF1E5E6A),
          shape: const CircleBorder(),
          child: Icon(AppIcons.add, size: 30.r, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: 24.h,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            color: Theme.of(context).cardColor,
            elevation: 0,
            child: SizedBox(
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   // Home Tab
                   Expanded(
                     child: IconButton(
                       style: ButtonStyle(
                         overlayColor: MaterialStateProperty.all(Colors.transparent),
                       ),
                       icon: Icon(
                         AppIcons.home,
                         color: _currentIndex == 0 
                             ? const Color(0xFF1E5E6A) 
                             : Theme.of(context).iconTheme.color?.withOpacity(0.5),
                         size: 32.r,
                       ),
                       onPressed: () => setState(() => _currentIndex = 0),
                     ),
                   ),
                   
                   // Spacer for the FAB
                   SizedBox(width: 60.w), 

                   // Settings Tab
                   Expanded(
                     child: IconButton(
                       style: ButtonStyle(
                         overlayColor: MaterialStateProperty.all(Colors.transparent),
                       ),
                       icon: Icon(
                         AppIcons.settings,
                         color: _currentIndex == 1 
                             ? const Color(0xFF1E5E6A) 
                             : Theme.of(context).iconTheme.color?.withOpacity(0.5),
                         size: 32.r,
                       ),
                       onPressed: () => setState(() => _currentIndex = 1),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
