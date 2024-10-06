import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/features/bottom_navigation/controller/bottom_navigation_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigationItemes extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final int index;
  final selectIcon;
  final unselectedIcon;
  const BottomNavigationItemes({
    super.key,
    required this.text,
    required this.onPressed,
    required this.index,
    this.selectIcon,
    this.unselectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationController>(
        builder: (context, provider, _) {
      return InkWell(
        onTap: () {
          onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              provider.currentScreen == index ? selectIcon : unselectedIcon,
              color: AppColor.primary,
              width: 18,
            ),
            SizedBox(height: 3),
            Text(
              "$text",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: provider.currentScreen == index
                      ? AppColor.primary
                      : AppColor.grey,
                  fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}
