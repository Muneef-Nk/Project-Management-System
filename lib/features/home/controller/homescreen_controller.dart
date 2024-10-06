import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/features/home/model/upcomming_model.dart';

class HomescreenController with ChangeNotifier {
  int totalOngoingProjects = 0;
  int totalCompletedProjects = 0;
  int totalPendingProjects = 0;
  double totalAdvanceAmount = 0.0;
  double totalBalanceAmount = 0.0;
  List<UpcommingModel> upcomingDeliveryDates = [];

  Future<void> getDetails() async {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    QuerySnapshot querySnapshot = await projects.get();

    totalOngoingProjects = 0;
    totalCompletedProjects = 0;
    totalPendingProjects = 0;
    totalAdvanceAmount = 0.0;
    totalBalanceAmount = 0.0;
    upcomingDeliveryDates.clear();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['status'] == 'In Progress') {
        totalOngoingProjects++;
      }
      if (data['status'] == 'Completed') {
        totalCompletedProjects++;
      }
      if (data['status'] == 'Pending') {
        totalPendingProjects++;
      }

      totalAdvanceAmount +=
          double.tryParse(data['advance_amount']?.toString() ?? '0') ?? 0.0;
      totalBalanceAmount +=
          double.tryParse(data['balance']?.toString() ?? '0') ?? 0.0;

      DateTime deliveryDate =
          DateTime.parse(data['delivery_date'] ?? DateTime.now().toString());

      upcomingDeliveryDates.add(UpcommingModel(
          projectName: data['project_name'], date: deliveryDate));
    }

    notifyListeners();
  }
}
