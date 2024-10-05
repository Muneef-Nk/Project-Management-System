import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/core/color_constanst/color_constants.dart';
import 'package:project_management_system/features/add_project/view/add_project_screen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DateTime> deliveryDates = [
      DateTime.now().add(const Duration(days: 1)), // Tomorrow
      DateTime.now().add(const Duration(days: 3)), // 3 days from now
      DateTime.now().add(const Duration(days: 5)), // 5 days from now
      DateTime.now().add(const Duration(days: 7)), // 1 week from now
    ];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              // GridView.builder with 4 items and 2 columns

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                itemCount: 4, // Number of items
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2, // Item width to height ratio
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      decoration: boxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ongoing"),
                              Icon(Icons.foggy),
                            ],
                          ),
                          Text("20"),
                        ],
                      ));
                },
              ),
              SizedBox(height: 20), // ListView.builder

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Insights',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add project logic here
                      print("clicked");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddProjectScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary, // Custom button color
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
                ],
              ),

              SizedBox(height: 30), // ListView.builder
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Upcommig delivery"),
              ),
              SizedBox(height: 10), // ListView.builder

              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: deliveryDates.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = deliveryDates[index];
                  String formattedDate =
                      DateFormat('MMM d, yyyy').format(date); // Format date

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: boxDecoration(),
                    child: ListTile(
                      leading: Icon(Icons.delivery_dining), // Icon for delivery
                      title: Text('B2C Bazazar'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formattedDate),
                          Text(
                              'Days left: ${date.difference(DateTime.now()).inDays} days'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.circular(8));
  }
}
