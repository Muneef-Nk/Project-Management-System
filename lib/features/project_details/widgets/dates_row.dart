import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';

class DateRow extends StatelessWidget {
  final String text;
  final String date;

  const DateRow({
    super.key,
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.calendar_today,
                  size: 15,
                  color: AppColor.primary,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
