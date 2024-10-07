import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/core/utils/loading.dart';
import 'package:project_management_system/features/add_project/view/add_project_screen.dart';
import 'package:project_management_system/features/payment_recorde/view/add_payment_screen.dart';
import 'package:project_management_system/features/project_details/controller/project_details_controller.dart';
import 'package:project_management_system/features/project_details/model/project_details_model.dart';
import 'package:project_management_system/features/project_details/widgets/amount_row.dart';
import 'package:project_management_system/features/project_details/widgets/dates_row.dart';
import 'package:project_management_system/features/project_list/model/project_list_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectListModel? projectListModel;

  ProjectDetailScreen({this.projectListModel});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  ProjectDetailsModel? projectDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            actions: [
              PopupMenuButton<String>(
                color: AppColor.white,
                icon: Icon(Icons.more_vert, color: AppColor.white),
                onSelected: (value) {
                  if (value == 'Edit Details') {
                    editProject(context);
                  } else if (value == 'Delete Project') {
                    deleteProject(context);
                  } else if (value == 'Add Payment') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPaymentScreeen(
                                  projectListModel: widget.projectListModel,
                                )));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Edit Details',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColor.primary,
                            size: 15,
                          ),
                          SizedBox(width: 8),
                          Text('Edit Details'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete Project',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: AppColor.primary,
                            size: 15,
                          ),
                          SizedBox(width: 8),
                          Text('Delete Project'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Add Payment',
                      child: Row(
                        children: [
                          Icon(Icons.currency_rupee,
                              size: 15, color: AppColor.primary),
                          SizedBox(width: 8),
                          Text('Add Payment'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('projects')
                .doc(widget.projectListModel?.id)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Loading(
                    color: AppColor.primary,
                  ),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Project not found.'));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Try Again'));
              }

              final projectData = snapshot.data!.data() as Map<String, dynamic>;
              projectDetailsModel =
                  ProjectDetailsModel.fromFirestore(projectData);

              var amountDue;
              double totalAmount =
                  double.tryParse(projectDetailsModel?.totalAmount ?? '0') ?? 0;
              double advancePaid =
                  double.tryParse(projectDetailsModel?.advancePaid ?? '0') ?? 0;
              amountDue = totalAmount + advancePaid;

              Provider.of<ProjectDetailsController>(context, listen: false)
                  .projectStatus = projectDetailsModel?.status;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectDetailsModel?.projectName ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        projectDetailsModel?.description ?? "",
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
                            projectDetailsModel?.clientName ?? '',
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
                          date: DateFormat('MMM d, yyyy').format(DateTime.parse(
                              projectDetailsModel?.startDate ?? ''))),
                      DateRow(
                          text: "Delivery Date",
                          date: DateFormat('MMM d, yyyy').format(DateTime.parse(
                              projectDetailsModel?.deliveryDate ?? ''))),
                      DateRow(
                          text: "Payment Due Date",
                          date: DateFormat('MMM d, yyyy').format(DateTime.parse(
                              projectDetailsModel?.paymentDueDate ?? ''))),
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
                          date: projectDetailsModel?.totalAmount.toString() ??
                              ''),
                      AmountRow(
                          text: "Advance Paid",
                          date: projectDetailsModel?.advancePaid.toString() ??
                              ''),
                      AmountRow(
                        text: "Amount Due",
                        date: amountDue.toString(),
                      ),
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
                              child: Consumer<ProjectDetailsController>(
                                  builder: (context, provider, _) {
                                return Container(
                                  margin: EdgeInsets.only(right: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: boxDecoration(),
                                  child: DropdownButton<String>(
                                    value: provider.projectStatus,
                                    borderRadius: BorderRadius.circular(10),
                                    dropdownColor: Colors.white,
                                    items: [
                                      'Pending',
                                      'In Progress',
                                      'Completed'
                                    ].map((String status) {
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
                                      if (newValue != null) {
                                        provider.updateStatus(
                                            context: context,
                                            newStatus: newValue,
                                            projectId:
                                                widget.projectListModel?.id ??
                                                    '');
                                      }
                                    },
                                    style: TextStyle(
                                      color: AppColor.primary,
                                    ),
                                    iconEnabledColor: AppColor.primary,
                                    isExpanded: true,
                                    underline: SizedBox.shrink(),
                                  ),
                                );
                              }),
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
        ),
        Consumer<ProjectDetailsController>(builder: (context, provider, _) {
          return provider.isLoading
              ? Center(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Loading(
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                )
              : SizedBox();
        })
      ],
    );
  }

  editProject(BuildContext context) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');

    DocumentSnapshot userDoc = await usersCollection.doc(id).get();

    if (userDoc.exists) {
      String userRole = userDoc['role'];

      if (userRole == 'Admin' || userRole == 'Project Manager') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProjectScreen(
                      isEdit: true,
                      projectModel: projectDetailsModel,
                      projectId: widget.projectListModel?.id,
                    )));
      } else {
        showSnackBar(
            context: context,
            message:
                "Only Admins and Project Managers can edit projects details.");
      }
    }
  }

  deleteProject(BuildContext context) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');

    DocumentSnapshot userDoc = await usersCollection.doc(id).get();

    print('inside ');

    if (userDoc.exists) {
      String userRole = userDoc['role'];

      if (userRole == 'Admin') {
        await projects.doc(widget.projectListModel?.id).delete();
        showSnackBar(
            context: context,
            message: "Project deleted successfully.",
            color: AppColor.primary);
        Navigator.of(context).pop();
      } else {
        showSnackBar(
            context: context, message: "Only Admins can delete projects.");
      }
    }
  }
}
