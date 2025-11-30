import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/core/constants/app_icons.dart';

import '../../HomeScreen/view/home_screen.dart';
import '../../ProfileScreen/view/profile_screen.dart';
import '../../SettingsScreen/view/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Start with Home tab selected

  final List<Widget> _screens = const [
    ProfileScreen(),
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20.r,
              offset: Offset(0, -5.h),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(AppIcons.person),
              selectedIcon: Icon(AppIcons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.home),
              selectedIcon: Icon(AppIcons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.settings),
              selectedIcon: Icon(AppIcons.settings),
              label: 'Settings',
            ),
          ],
          indicatorColor: const Color(0xFF1E5E6A).withOpacity(0.2),
          height: 80.h,
        ),
      ),
    );
  }
}
