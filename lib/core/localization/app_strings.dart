import 'package:flutter/material.dart';

abstract class AppStrings {
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ?? EnStrings();
  }

  String get appTitle;
  String get home;
  String get settings;
  String get profile;
  String get darkMode;
  String get notifications;
  String get backupTasks;
  String get clearData;
  String get general;
  String get dataStorage;
  String get searchTasks;
  String get noTasksYet;
  String get tapToAdd;
  String get addNewTask;
  String get enterTaskTitle;
  String get cancel;
  String get addTask;
  String taskDeleted(String taskTitle);
  String get undo;
  String tasksCount(int count);
  String get language;
  String get changeLanguage;
}

class EnStrings extends AppStrings {
  @override
  String get appTitle => "Momentum";
  @override
  String get home => "Home";
  @override
  String get settings => "Settings";
  @override
  String get profile => "Profile";
  @override
  String get darkMode => "Dark Mode";
  @override
  String get notifications => "Notifications";
  @override
  String get backupTasks => "Backup Tasks";
  @override
  String get clearData => "Clear Data";
  @override
  String get general => "General";
  @override
  String get dataStorage => "Data & Storage";
  @override
  String get searchTasks => "Search tasks...";
  @override
  String get noTasksYet => "No tasks yet";
  @override
  String get tapToAdd => "Tap the + button to add your first task";
  @override
  String get addNewTask => "Add New Task";
  @override
  String get enterTaskTitle => "Enter task title";
  @override
  String get cancel => "Cancel";
  @override
  String get addTask => "Add Task";
  @override
  String taskDeleted(String taskTitle) => "$taskTitle has been deleted";
  @override
  String get undo => "Undo";
  @override
  String tasksCount(int count) => count == 0 ? "0 tasks" : count == 1 ? "1 task" : "$count tasks";
  @override
  String get language => "Language";
  @override
  String get changeLanguage => "Change Language";
}

class ArStrings extends AppStrings {
  @override
  String get appTitle => "Momentum";
  @override
  String get home => "الرئيسية";
  @override
  String get settings => "الإعدادات";
  @override
  String get profile => "الملف الشخصي";
  @override
  String get darkMode => "الوضع الداكن";
  @override
  String get notifications => "الإشعارات";
  @override
  String get backupTasks => "نسخ احتياطي للمهام";
  @override
  String get clearData => "مسح البيانات";
  @override
  String get general => "عام";
  @override
  String get dataStorage => "البيانات والتخزين";
  @override
  String get searchTasks => "البحث عن مهام...";
  @override
  String get noTasksYet => "لا توجد مهام بعد";
  @override
  String get tapToAdd => "اضغط على زر + لإضافة مهمتك الأولى";
  @override
  String get addNewTask => "إضافة مهمة جديدة";
  @override
  String get enterTaskTitle => "أدخل عنوان المهمة";
  @override
  String get cancel => "إلغاء";
  @override
  String get addTask => "إضافة مهمة";
  @override
  String taskDeleted(String taskTitle) => "تم حذف $taskTitle";
  @override
  String get undo => "تراجع";
  @override
  String tasksCount(int count) => count == 0 ? "0 مهام" : count == 1 ? "مهمة واحدة" : count == 2 ? "مهمتان" : "$count مهام";
  @override
  String get language => "اللغة";
  @override
  String get changeLanguage => "تغيير اللغة";
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return ArStrings();
      case 'en':
      default:
        return EnStrings();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}

extension LocalizationExtension on BuildContext {
  AppStrings get tr => AppStrings.of(this);
}
