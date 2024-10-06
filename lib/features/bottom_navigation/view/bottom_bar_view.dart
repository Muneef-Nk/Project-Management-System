import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/features/bottom_navigation/controller/bottom_navigation_controller.dart';
import 'package:project_management_system/features/bottom_navigation/widgets/bottom_items.dart';
import 'package:provider/provider.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationController>(
        builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        body: provider.screens[provider.currentScreen],
        bottomNavigationBar: Container(
          color: AppColor.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavigationItemes(
                text: "Home",
                index: 0,
                selectIcon: "assets/home_selected.png",
                unselectedIcon: "assets/home_unselected.png",
                onPressed: () {
                  provider.changeScreen(0);
                },
              ),
              BottomNavigationItemes(
                text: "Projects",
                index: 1,
                selectIcon: "assets/selectedproject.png",
                unselectedIcon: "assets/project.png",
                onPressed: () {
                  provider.changeScreen(1);
                },
              ),
              BottomNavigationItemes(
                text: "Reports",
                index: 2,
                selectIcon: "assets/selected_report.png",
                unselectedIcon: "assets/report.png",
                onPressed: () {
                  provider.changeScreen(2);
                },
              ),
              BottomNavigationItemes(
                text: "Notifications",
                index: 3,
                selectIcon: "assets/selected_notification.png",
                unselectedIcon: "assets/notification.png",
                onPressed: () {
                  provider.changeScreen(3);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
