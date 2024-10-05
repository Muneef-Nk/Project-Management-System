import 'package:flutter/material.dart';
import 'package:project_management_system/core/color_constanst/color_constants.dart';
import 'package:project_management_system/features/home/view/homescreen.dart';
import 'package:project_management_system/features/project_list/project_list_screen.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key});

  final List<Widget> screens = [
    Homescreen(),
    ProjectListScreen(),
    Homescreen(),
    Homescreen(),
  ];

  int currentScreen = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: screens[currentScreen],
      bottomNavigationBar: Container(
        color: AppColor.white,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomNavigationItemes(
              text: "Home",
            ),
            BottomNavigationItemes(
              text: "Projects",
            ),
            BottomNavigationItemes(
              text: "Reports",
            ),
            BottomNavigationItemes(
              text: "Notifications",
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationItemes extends StatelessWidget {
  final String text;
  const BottomNavigationItemes({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/home_selected.png",
          color: AppColor.primary,
          width: 18,
        ),
        SizedBox(height: 3),
        Text(
          "$text",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              fontSize: 12),
        ),
      ],
    );
  }
}
