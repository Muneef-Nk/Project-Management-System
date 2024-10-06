import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';

class ProjectDetailsController with ChangeNotifier {
  String? projectStatus;
  bool isLoading = false;

  Future<void> updateStatus({
    required String projectId,
    required String newStatus,
    required BuildContext context,
  }) async {
    projectStatus = newStatus;
    isLoading = true;
    notifyListeners();

    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    await projects.doc(projectId).update({
      'status': newStatus,
    }).then(
      (value) {
        showSnackBar(
            context: context,
            message: 'Project Status Changed',
            color: AppColor.primary);
      },
    );
    isLoading = false;
    notifyListeners();
  }
}
