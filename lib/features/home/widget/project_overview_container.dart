import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/features/home/controller/homescreen_controller.dart';
import 'package:provider/provider.dart';

class ProjectStatusOvervewContainer extends StatelessWidget {
  const ProjectStatusOvervewContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomescreenController>(builder: (context, provider, _) {
      return Container(
        decoration: boxDecoration(),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'Project Status Overview',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: provider.totalPendingProjects.toDouble(),
                          color: Colors.red,
                          width: 10,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: provider.totalOngoingProjects.toDouble(),
                          color: Colors.orange,
                          width: 10,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: provider.totalCompletedProjects.toDouble(),
                          color: Colors.green,
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Pending',
                                style: TextStyle(fontSize: 10),
                              );
                            case 1:
                              return const Text(
                                'Ongoing',
                                style: TextStyle(fontSize: 10),
                              );
                            case 2:
                              return const Text(
                                'Completed',
                                style: TextStyle(fontSize: 10),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
