import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/core/constants/app_icons.dart';
import 'package:momentum/core/theme/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'General',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ListTile(
                        leading: Icon(AppIcons.darkMode, size: 24.r),
                        title: Text('Dark Mode', style: TextStyle(fontSize: 16.sp)),
                        trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, themeMode) {
                            return Switch(
                              value: themeMode == ThemeMode.dark,
                              onChanged: (value) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            );
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(AppIcons.notifications, size: 24.r),
                        title: Text('Notifications', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        onTap: () {},
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Data & Storage',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ListTile(
                        leading: Icon(AppIcons.backup, size: 24.r),
                        title: Text('Backup Tasks', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(AppIcons.clearData, size: 24.r),
                        title: Text('Clear Data', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
