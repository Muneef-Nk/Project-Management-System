import 'package:flutter/material.dart';
import 'package:project_management_system/features/home/view/homescreen.dart';
import 'package:project_management_system/features/notification/view/notification_screen.dart';
import 'package:project_management_system/features/project_list/view/project_list_screen.dart';
import 'package:project_management_system/features/reports/view/reports_screen.dart';

class BottomNavigationController with ChangeNotifier {
  int currentScreen = 0;

  final List<Widget> screens = [
    Homescreen(),
    ProjectListScreen(),
    ReportsScreen(),
    NotificationScreen(),
  ];

  changeScreen(int index) {
    currentScreen = index;
    notifyListeners();
  }
}
