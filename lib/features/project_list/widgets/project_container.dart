import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/payment_recorde/view/payment_record_list_screen.dart';
import 'package:project_management_system/features/project_details/view/project_details_screen.dart';
import 'package:project_management_system/features/project_list/model/project_list_model.dart';

class ProjectContainer extends StatelessWidget {
  final ProjectListModel project;

  const ProjectContainer({
    super.key,
    required this.project,
  });

  String formatDeliveryDate(DateTime? deliveryDate) {
    if (deliveryDate == null) return 'Not Set';
    return DateFormat('yyyy-MM-dd').format(deliveryDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/business-man.png',
                      width: 20,
                    ),
                    Text(
                      "${project.clientName} Muhammed Muneef ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: project.status == "Completed"
                      ? Colors.green.withOpacity(0.1)
                      : project.status == "In Progress"
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  project.status,
                  style: TextStyle(
                    color: project.status == "Completed"
                        ? Colors.green
                        : project.status == "In Progress"
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: AppColor.primary,
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                "Delivery: ${formatDeliveryDate(project.deliveryDate)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                    size: 14,
                  ),
                  Text(
                    "Paid: ₹${project.advanceAmount}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.money_off,
                    color: Colors.red,
                    size: 14,
                  ),
                  Text(
                    "Balance: ₹${project.balance}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.bg)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(
                        projectListModel: project,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: AppColor.primary,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "View Details",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.bg)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentRecordListScreen(
                        projectListModel: project,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: AppColor.primary,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Records",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
