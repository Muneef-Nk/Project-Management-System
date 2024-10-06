import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';

class ReportTile extends StatelessWidget {
  final String label;
  final String subText;
  final String amount;
  final Color amountColor;

  const ReportTile({
    super.key,
    required this.label,
    required this.subText,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subText,
            style: TextStyle(
              color: AppColor.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₹$amount',
            style: TextStyle(
              color: amountColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
