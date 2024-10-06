import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';

class PaymentRecordController with ChangeNotifier {
  bool isLoading = false;

  Future<void> addPayment({
    required BuildContext context,
    required String amount,
    required String total,
    required String id,
  }) async {
    isLoading = true;
    notifyListeners();

    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    CollectionReference paymentRecords = FirebaseFirestore.instance
        .collection('projects')
        .doc(id)
        .collection('payment_records');

    DocumentSnapshot projectSnapshot = await projects.doc(id).get();

    try {
      double currentAdvance = projectSnapshot['advance_amount'] is double
          ? projectSnapshot['advance_amount']
          : double.tryParse(projectSnapshot['advance_amount'].toString()) ??
              0.0;

      double currentBalance = projectSnapshot['balance'] is double
          ? projectSnapshot['balance']
          : double.tryParse(projectSnapshot['balance'].toString()) ?? 0.0;

      double paymentAmount = double.tryParse(amount) ?? 0.0;

      double updatedAdvance = currentAdvance + paymentAmount;
      double updatedBalance = currentBalance - paymentAmount;

      if (updatedBalance < 0) {
        showSnackBar(
          context: context,
          message: "Payment exceeds the current balance!",
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      await projects.doc(id).update({
        'advance_amount': updatedAdvance,
        'balance': updatedBalance,
      });

      await paymentRecords.add({
        'total': total,
        'advance': updatedAdvance,
        'balance': updatedBalance,
        'timestamp': FieldValue.serverTimestamp(),
      });

      showSnackBar(
        context: context,
        message: "Payment added successfully!",
        color: AppColor.primary,
      );

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}
