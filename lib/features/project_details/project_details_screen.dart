import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/project_details/model/project_details_model.dart';
import 'package:project_management_system/features/project_details/widgets/amount_row.dart';
import 'package:project_management_system/features/project_details/widgets/dates_row.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  ProjectDetailScreen({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: AppColor.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Project Details',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Project not found.'));
          }

          final projectData = snapshot.data!.data() as Map<String, dynamic>;
          final project = ProjectDetailsModel.fromFirestore(projectData);

          var amountdue;
          double totalAmount = double.tryParse(project.totalAmount) ?? 0;
          double advancePaid = double.tryParse(project.advancePaid) ?? 0;
          amountdue = totalAmount - advancePaid;

          return Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.projectName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    project.description,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: AppColor.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Client:  ',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        project.clientName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 0.5),
                  SizedBox(height: 10),
                  Text(
                    'Project Dates',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  DateRow(
                      text: "Start Date",
                      date: DateFormat('MMM d, yyyy')
                          .format(DateTime.parse(project.startDate))),
                  DateRow(
                      text: "Delivery Date",
                      date: DateFormat('MMM d, yyyy')
                          .format(DateTime.parse(project.deliveryDate))),
                  DateRow(
                      text: "Payment Due Date",
                      date: DateFormat('MMM d, yyyy')
                          .format(DateTime.parse(project.paymentDueDate))),
                  SizedBox(height: 10),
                  Divider(thickness: 0.5),
                  SizedBox(height: 10),
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  AmountRow(
                      text: "Total Amount",
                      date: project.totalAmount.toString()),
                  AmountRow(
                      text: "Advance Paid",
                      date: project.advancePaid.toString()),
                  AmountRow(text: "Amount Due", date: amountdue.toString()),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Project Status',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: boxDecoration(),
                            child: DropdownButton<String>(
                              value: project.status,
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor: Colors.white,
                              items: ['Pending', 'In Progress', 'Completed']
                                  .map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: AppColor.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Update project status logic can be added
                              },
                              style: TextStyle(
                                color: AppColor.primary,
                              ),
                              iconEnabledColor: AppColor.primary,
                              isExpanded: true,
                              underline: SizedBox.shrink(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
