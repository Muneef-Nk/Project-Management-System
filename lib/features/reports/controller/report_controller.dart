import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/reports/model/completed_project_model.dart';
import 'package:project_management_system/features/reports/model/ongoing_project_model.dart';

class ReportController with ChangeNotifier {
  List<OngoingProjectModel> ongoingProjects = [];
  List<CompletedProjectModel> completedProjects = [];
  int advancePayments = 0;
  double totalBalanceAmount = 0.0;

  Future<void> getDetails() async {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    QuerySnapshot querySnapshot = await projects.get();

    List<OngoingProjectModel> tempOngoingProjects = [];
    List<CompletedProjectModel> tempCompletedProjects = [];
    int totalAdvancePayments = 0;
    double totalBalance = 0.0;

    querySnapshot.docs.forEach((doc) {
      String status = doc['status'] ?? '';
      String projectName = doc['project_name'];
      String advancePayment = doc['advance_amount']?.toString() ?? '0';
      String balance = doc['balance']?.toString() ?? '0';
      DateTime? deliveryDate = DateTime.parse(doc['delivery_date']);

      if (status == 'In Progress') {
        OngoingProjectModel ongoingProject = OngoingProjectModel(
          projectName: projectName,
          balance: balance,
          date: deliveryDate,
        );
        tempOngoingProjects.add(ongoingProject);

        totalAdvancePayments += int.tryParse(advancePayment) ?? 0;
        totalBalance += double.tryParse(balance) ?? 0.0;
      } else if (status == 'Completed') {
        CompletedProjectModel completedProject = CompletedProjectModel(
          projectName: projectName,
          amountPaid: advancePayment,
          date: deliveryDate,
        );
        tempCompletedProjects.add(completedProject);
        totalBalance += double.tryParse(balance) ?? 0.0;
      }
    });

    ongoingProjects = tempOngoingProjects;
    completedProjects = tempCompletedProjects;
    advancePayments = totalAdvancePayments;
    totalBalanceAmount = totalBalance;

    notifyListeners();
  }

  Future<void> downloadPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final dir = Directory('/storage/emulated/0/Download');

      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${dir.path}/project_report_$timestamp.pdf';

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text('Project Reports',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Total Advance Payments: $advancePayments',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Total Balance Due: $totalBalanceAmount',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Ongoing Projects',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...ongoingProjects.map((project) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Project Name: ${project.projectName}'),
                    pw.Text('Balance: ${project.balance}'),
                    pw.Text('Deadline: ${project.date.toLocal()}'),
                    pw.Text(
                        '---------------------------------------------------------'),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text('Completed Projects:',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...completedProjects.map((project) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("Project Name : ${project.projectName}"),
                    pw.Text('Amount Paid: ${project.amountPaid}'),
                    pw.Text('Delivery Date: ${project.date.toLocal()}'),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      );

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print("PDF saved successfully at $filePath");
      showSnackBar(
          context: context,
          message: "PDF saved successfully at $filePath",
          color: AppColor.primary);

      file.open();
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }
}
