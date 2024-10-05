import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/features/project_list/model/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  ProjectDetailScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.projectTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${project.clientName}',
                style: TextStyle(fontSize: 18)),
            Text(
                'Delivery Date: ${DateFormat('MMM d, yyyy').format(project.deliveryDate)}',
                style: TextStyle(fontSize: 18)),
            Text('Status: ${project.status}', style: TextStyle(fontSize: 18)),
            Text('Advance Paid: \$${project.advancePaid}',
                style: TextStyle(fontSize: 18)),
            Text('Balance Due: \$${project.balanceDue}',
                style: TextStyle(fontSize: 18)),
            // Add fields for editing payment records
            // Use TextFields or other widgets for input
          ],
        ),
      ),
    );
  }
}
