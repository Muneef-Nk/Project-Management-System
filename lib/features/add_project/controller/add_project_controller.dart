import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';

class AddProjectController with ChangeNotifier {
  DateTime? startDate;
  DateTime? deliveryDate;
  DateTime? paymentDueDate;
  String? status;
  final List<String> statusOptions = ['Pending', 'In Progress', 'Completed'];
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addProject({
    required BuildContext context,
    required String clientName,
    required String projectName,
    required String projectDescription,
    required String startDate,
    required String deliveryDate,
    required String projectAmount,
    required String advanceAmount,
    required String balance,
    required String amountDue,
    required String status,
    required bool isEdit,
    String? projectId,
  }) {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    setLoading(true);

    final Map<String, dynamic> projectData = {
      'client_name': clientName,
      'project_name': projectName,
      'project_description': projectDescription,
      'start_date': startDate,
      'delivery_date': deliveryDate,
      'project_amount': projectAmount,
      'advance_amount': advanceAmount,
      'balance': balance,
      'payment_due_date': amountDue,
      'status': status,
      'created_at': FieldValue.serverTimestamp(),
    };

    if (isEdit) {
      print('your project id ${projectId}');
      projects.doc(projectId).update(projectData).then((value) {
        setLoading(false);
        showSnackBar(
          context: context,
          message: "Project updated successfully!",
          color: AppColor.primary,
        );
        Navigator.pop(context);
      }).catchError((error) {
        setLoading(false);
        showSnackBar(
          context: context,
          message: "Failed to update project",
        );
      });
    } else {
      projects.add(projectData).then((DocumentReference docRef) async {
        setLoading(false);
        String newProjectId = docRef.id;

        CollectionReference paymentRecords = FirebaseFirestore.instance
            .collection('projects')
            .doc(newProjectId)
            .collection('payment_records');

        await paymentRecords.add({
          'total': projectAmount,
          'advance': advanceAmount,
          'balance': balance,
          'timestamp': FieldValue.serverTimestamp(),
        });

        showSnackBar(
            context: context,
            message: "Project added successfully!",
            color: AppColor.primary);

        Navigator.pop(context);
      }).catchError((error) {
        setLoading(false);
        showSnackBar(
          context: context,
          message: "Failed to add project",
        );
      });
    }
  }
}
