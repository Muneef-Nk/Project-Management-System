import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/home/controller/homescreen_controller.dart';
import 'package:project_management_system/features/home/widget/gridview_container.dart';
import 'package:project_management_system/features/home/widget/project_overview_container.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomescreenController>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        surfaceTintColor: AppColor.primary,
        title: Text(
          "Spine Codes",
          style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<HomescreenController>(context, listen: false)
                    .logout(context);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 18,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child:
              Consumer<HomescreenController>(builder: (context, provider, _) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: HomeContainer(
                        icon: 'assets/launch.png',
                        value: provider.totalOngoingProjects.toString(),
                        label: 'Ongoing',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: HomeContainer(
                        icon: 'assets/flag.png',
                        value: provider.totalCompletedProjects.toString(),
                        label: 'Completed',
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                HomeContainer(
                  icon: 'assets/send.png',
                  value: '₹${provider.totalAdvanceAmount}',
                  label: 'Total Amounts Received',
                ),
                SizedBox(height: 20),
                HomeContainer(
                  icon: 'assets/money.png',
                  value: '₹${provider.totalBalanceAmount}',
                  label: 'Balance Amounts',
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: boxDecoration(),
                  padding: EdgeInsets.only(top: 15, left: 15, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start a New Project!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Click the button below to add your project and manage your tasks effectively!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              provider.addProject(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColor.primary, // Custom button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add Project',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Image.asset(
                            'assets/virtual-reality.png',
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                ProjectStatusOvervewContainer(),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Upcommig delivery",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.upcomingDeliveryDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date = provider.upcomingDeliveryDates[index].date;
                    String formattedDate =
                        DateFormat('MMM d, yyyy').format(date);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: boxDecoration(),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/upcoming.png',
                          width: 30,
                        ),
                        title: Text(
                          provider.upcomingDeliveryDates[index].projectName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppColor.grey,
                              ),
                            ),
                            Text(
                              'Days left: ${date.difference(DateTime.now()).inDays} days',
                              style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
