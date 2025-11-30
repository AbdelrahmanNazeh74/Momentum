import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/core/constants/app_icons.dart';
import 'package:momentum/core/localization/language_cubit.dart';
import 'package:momentum/core/theme/theme_cubit.dart';
import 'package:momentum/core/localization/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
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
                        l10n.general,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                      ),
                      SizedBox(height: 20.h),
                      ListTile(
                        leading: Icon(AppIcons.darkMode, size: 24.r),
                        title: Text(l10n.darkMode,
                            style: TextStyle(fontSize: 16.sp)),
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
                        leading: Icon(Icons.language, size: 24.r),
                        title: Text(l10n.language,
                            style: TextStyle(fontSize: 16.sp)),
                        onTap: () => _showLanguageDialog(context),
                        trailing: Icon(AppIcons.arrowForward, size: 16.r),
                      ),
                      ListTile(
                        leading: Icon(AppIcons.notifications, size: 24.r),
                        title: Text(l10n.notifications,
                            style: TextStyle(fontSize: 16.sp)),
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

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppStrings.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(l10n.changeLanguage, style: TextStyle(fontSize: 20.sp)),
        content: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, currentLocale) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  leading: Radio<String>(
                    value: 'en',
                    groupValue: currentLocale.languageCode,
                    onChanged: (value) {
                      context.read<LanguageCubit>().changeLanguage(value!);
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('العربية'),
                  leading: Radio<String>(
                    value: 'ar',
                    groupValue: currentLocale.languageCode,
                    onChanged: (value) {
                      context.read<LanguageCubit>().changeLanguage(value!);
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('ar');
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
