import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/core/constants/app_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              CircleAvatar(
                radius: 60.r,
                backgroundColor: const Color(0xFF3A86A8),
                child: Icon(
                  AppIcons.person,
                  size: 80.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Manage your account and preferences',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 48.h),
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
                        'Profile Options',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ListTile(
                        leading: Icon(AppIcons.editProfile, size: 24.r),
                        title: Text('Edit Profile', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(AppIcons.security, size: 24.r),
                        title: Text('Account Settings', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(AppIcons.privacy, size: 24.r),
                        title: Text('Privacy & Security', style: TextStyle(fontSize: 16.sp)),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
