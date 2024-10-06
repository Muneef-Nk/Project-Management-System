import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/features/payment_recorde/view/add_payment_screen.dart';
import 'package:project_management_system/features/payment_recorde/widgets/payment_record_container.dart';
import 'package:project_management_system/features/project_list/model/project_list_model.dart';

class PaymentRecordListScreen extends StatelessWidget {
  final ProjectListModel? projectListModel;

  const PaymentRecordListScreen({this.projectListModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Payment Records',
          style: TextStyle(
              color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppColor.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPaymentScreeen(
                    projectListModel: projectListModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .doc(projectListModel?.id)
            .collection('payment_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No payment records found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var paymentRecord =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              String balance = paymentRecord['balance'].toString();
              String advance = paymentRecord['advance'].toString();
              Timestamp timestamp =
                  paymentRecord['timestamp'] ?? Timestamp.now();

              String formattedDate =
                  DateFormat('MMM d, yyyy, hh:mm a').format(timestamp.toDate());

              return PayementRecordContainer(
                  formattedDate: formattedDate,
                  advance: advance,
                  balance: balance);
            },
          );
        },
      ),
    );
  }
}
