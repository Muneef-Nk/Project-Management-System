import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';

class HomeContainer extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  const HomeContainer({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  icon,
                  width: 30,
                )
              ],
            ),
            Text(
              "$value",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
          ],
        ));
  }
}
