import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';

class AmountRow extends StatelessWidget {
  final String text;
  final String date;

  const AmountRow({
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
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.currency_rupee,
                size: 15,
                color: AppColor.primary,
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
        ],
      ),
    );
  }
}
