import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/reports/controller/report_controller.dart';
import 'package:project_management_system/features/reports/widgets/reporttile.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReportController>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(
          'Project Reports',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppColor.white,
            ),
            icon: Icon(Icons.download, color: AppColor.white),
            label: Text(
              "Download PDF",
              style: TextStyle(
                color: AppColor.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              Provider.of<ReportController>(context, listen: false)
                  .downloadPdf(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<ReportController>(builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(15),
                decoration: boxDecoration(),
                child: Column(
                  children: [
                    ReportTile(
                      label: "Advance Payments",
                      subText: "received for all ongoing projects",
                      amountColor: Colors.green,
                      amount: provider.advancePayments.toString(),
                    ),
                    ReportTile(
                      label: "Total Balance Due",
                      subText: "for all clients/projects",
                      amountColor: Colors.green,
                      amount: provider.totalBalanceAmount.toString(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ongoing Project',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    provider.ongoingProjects.length == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                ' Ongoing projects not found.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: provider.ongoingProjects.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(
                                  thickness: 0.3,
                                ),
                            itemBuilder: (context, index) {
                              return ReportTile(
                                label:
                                    provider.ongoingProjects[index].projectName,
                                subText: provider.ongoingProjects[index].date
                                    .toString(),
                                amountColor: Colors.red,
                                amount: provider.ongoingProjects[index].balance,
                              );
                            }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 10,
                color: AppColor.white,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Projects',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    provider.completedProjects.length == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Completed project not found',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: provider.completedProjects.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(
                                  thickness: 0.3,
                                ),
                            itemBuilder: (context, index) {
                              return ReportTile(
                                label: provider
                                    .completedProjects[index].projectName,
                                subText: provider.completedProjects[index].date
                                    .toString(),
                                amountColor: Colors.green,
                                amount: provider
                                    .completedProjects[index].amountPaid,
                              );
                            }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
