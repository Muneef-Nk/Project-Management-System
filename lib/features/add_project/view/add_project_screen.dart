import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/custom_textfield.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/core/utils/loading.dart';
import 'package:project_management_system/features/add_project/controller/add_project_controller.dart';
import 'package:project_management_system/features/project_details/model/project_details_model.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  final bool isEdit;
  final ProjectDetailsModel? projectModel;
  final String? projectId;

  const AddProjectScreen({
    super.key,
    required this.isEdit,
    this.projectModel,
    this.projectId,
  });
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      getData();
    } else {
      restoreData();
    }
  }

  getData() {
    _clientNameController.text = widget.projectModel?.clientName ?? '';
    _projectTitleController.text = widget.projectModel?.projectName ?? '';
    _projectDescriptionController.text = widget.projectModel?.description ?? '';
    _startDate = DateTime.parse(widget.projectModel?.startDate ?? '');
    _deliveryDate = DateTime.parse(widget.projectModel?.deliveryDate ?? '');
    _totalAmountController.text = widget.projectModel?.totalAmount ?? '';
    _advanceAmountController.text = widget.projectModel?.advancePaid ?? '';
    _paymentDueDate = DateTime.parse(widget.projectModel?.paymentDueDate ?? '');
    _status = widget.projectModel?.status ?? '';
    balanceAmount();
  }

  restoreData() {
    _clientNameController.clear();
    _projectTitleController.clear();
    _projectDescriptionController.clear();
    _totalAmountController.clear();
    _advanceAmountController.clear();
    _balanceDueController.clear();
    _startDate = null;
    _deliveryDate = null;
    _paymentDueDate = null;
    _status = null;
  }

  final _clientNameController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _balanceDueController = TextEditingController();
  DateTime? _startDate;
  DateTime? _deliveryDate;
  DateTime? _paymentDueDate;
  String? _status;

  final _formKey = GlobalKey<FormState>();

  balanceAmount() {
    double total = double.tryParse(_totalAmountController.text) ?? 0;
    double advance = double.tryParse(_advanceAmountController.text) ?? 0;
    _balanceDueController.text = (total - advance).toStringAsFixed(2);
    setState(() {});
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _projectTitleController.dispose();
    _projectDescriptionController.dispose();
    _totalAmountController.dispose();
    _advanceAmountController.dispose();
    _balanceDueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        showSnackBar(context: context, message: 'Please select a start date!');
        return;
      }
      if (_deliveryDate == null) {
        showSnackBar(
            context: context, message: 'Please select a delivery date!');
        return;
      }
      if (_paymentDueDate == null) {
        showSnackBar(
            context: context, message: 'Please select a payment due date!');
        return;
      }

      if (_balanceDueController.text == "0.00") {
        showSnackBar(context: context, message: 'Balance should not be zero!');
        return;
      }

      if (widget.isEdit) {
        Provider.of<AddProjectController>(context, listen: false).addProject(
          isEdit: true,
          context: context,
          advanceAmount: _advanceAmountController.text,
          amountDue: _paymentDueDate.toString(),
          balance: _balanceDueController.text,
          clientName: _clientNameController.text,
          deliveryDate: _deliveryDate.toString(),
          projectAmount: _totalAmountController.text,
          projectDescription: _projectDescriptionController.text,
          projectName: _projectTitleController.text,
          startDate: _startDate.toString(),
          status: _status.toString(),
          projectId: widget.projectId,
        );
      } else {
        Provider.of<AddProjectController>(context, listen: false).addProject(
          isEdit: false,
          context: context,
          advanceAmount: _advanceAmountController.text,
          amountDue: _paymentDueDate.toString(),
          balance: _balanceDueController.text,
          clientName: _clientNameController.text,
          deliveryDate: _deliveryDate.toString(),
          projectAmount: _totalAmountController.text,
          projectDescription: _projectDescriptionController.text,
          projectName: _projectTitleController.text,
          startDate: _startDate.toString(),
          status: _status.toString(),
        );
      }
    } else {
      showSnackBar(
          context: context, message: 'Please fill out all required fields!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColor.white,
            ),
          ),
          backgroundColor: AppColor.primary,
          title: Text(
            'Add New Project',
            style: TextStyle(
              color: AppColor.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Consumer<AddProjectController>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: CustomTextField(
                    controller: _clientNameController,
                    hintText: "Client Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter client name';
                      }
                      return null;
                    },
                  ),
                ),
                CustomTextField(
                  controller: _projectTitleController,
                  hintText: "Project Title",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project title';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _projectDescriptionController,
                  hintText: "Project Description",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project description';
                    }
                    return null;
                  },
                ),
                CustomDatePicker(
                  label: 'Select Start Date',
                  selectedDate: _startDate,
                  onDatePicked: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
                CustomDatePicker(
                  label: 'Select Delivery Date',
                  selectedDate: _deliveryDate,
                  onDatePicked: (date) {
                    setState(() {
                      _deliveryDate = date;
                    });
                  },
                ),
                CustomTextField(
                  controller: _totalAmountController,
                  hintText: "Total Project Amount",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total amount';
                    } else if (double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0) {
                      return 'Please enter a valid positive amount';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    balanceAmount();
                  },
                ),
                CustomTextField(
                  controller: _advanceAmountController,
                  hintText: "Advance Amount Paid",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter advance amount';
                    } else if (double.tryParse(value) == null ||
                        double.tryParse(value)! < 0) {
                      return 'Please enter a valid positive amount';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    balanceAmount();
                  },
                ),
                CustomTextField(
                  controller: TextEditingController(
                      text: '₹ ${_balanceDueController.text}'),
                  hintText: "Balance Amount Due",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    balanceAmount();
                  },
                ),
                CustomDatePicker(
                  label: 'Select Payment Due Date',
                  selectedDate: _paymentDueDate,
                  onDatePicked: (date) {
                    setState(() {
                      _paymentDueDate = date;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.primarylight,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    hint: Text(
                      'Select Status',
                      style: TextStyle(fontSize: 12),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: provider.statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _status = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a status';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: InkWell(
                    onTap: () {
                      _submitForm();
                    },
                    child: Ink(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(8)),
                      child: provider.isLoading
                          ? Center(child: Loading())
                          : Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDatePicked;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          ).then((date) {
            if (date != null) {
              onDatePicked(date);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
            color: AppColor.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColor.primarylight,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? label
                    : DateFormat('MMM d, yyyy').format(selectedDate!),
                style: TextStyle(fontSize: 12),
              ),
              Icon(Icons.calendar_month, color: AppColor.primary),
            ],
          ),
        ),
      ),
    );
  }
}
