import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/custom_textfield.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/core/utils/loading.dart';
import 'package:project_management_system/features/payment_recorde/controller/payment_record_controller.dart';
import 'package:project_management_system/features/project_list/model/project_list_model.dart';
import 'package:provider/provider.dart';

class AddPaymentScreeen extends StatefulWidget {
  final ProjectListModel? projectListModel;
  const AddPaymentScreeen({super.key, this.projectListModel});

  @override
  State<AddPaymentScreeen> createState() => _AddPaymentScreeenState();
}

class _AddPaymentScreeenState extends State<AddPaymentScreeen> {
  final totalController = TextEditingController();
  final paidController = TextEditingController();
  final balanceController = TextEditingController();
  final additionalAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    totalController.text = widget.projectListModel?.total.toString() ?? '';
    paidController.text =
        widget.projectListModel?.advanceAmount.toString() ?? '';

    double total = widget.projectListModel?.total ?? 0;
    double advanceAmount = widget.projectListModel?.advanceAmount ?? 0;

    balanceController.text = (total - advanceAmount).toString();

    print(widget.projectListModel?.id);
  }

  @override
  void dispose() {
    totalController.dispose();
    paidController.dispose();
    balanceController.dispose();
    additionalAmountController.dispose();
    super.dispose();
  }

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
          'Add Payment',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: totalController,
              hintText: "Total Amount",
              maxLines: 1,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total amount';
                }
                return null;
              },
            ),
            CustomTextField(
              controller: paidController,
              hintText: "Amount Paid",
              maxLines: 1,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount paid';
                }
                return null;
              },
            ),
            CustomTextField(
              controller: balanceController,
              hintText: "Balance Amount",
              maxLines: 1,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter balance amount';
                }
                return null;
              },
            ),
            CustomTextField(
              controller: additionalAmountController,
              hintText: "Add Amount",
              keyboardType: TextInputType.number,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount to add';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Consumer<PaymentRecordController>(builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (additionalAmountController.text.isNotEmpty) {
                      Provider.of<PaymentRecordController>(context,
                              listen: false)
                          .addPayment(
                        amount: additionalAmountController.text,
                        context: context,
                        total: totalController.text,
                        id: widget.projectListModel?.id.toString() ?? '',
                      );
                    } else {
                      showSnackBar(
                          context: context, message: 'Please enter an amount');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: provider.isLoading
                      ? Center(child: Loading())
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'Save Payment',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
