import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_system/features/project_details/project_details_screen.dart';
import 'package:project_management_system/features/project_list/model/project_model.dart';

class ProjectListScreen extends StatefulWidget {
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Project> projectss = [
    Project(
      projectTitle: 'Project Alpha',
      clientName: 'Client A',
      deliveryDate: DateTime.now().add(Duration(days: 10)),
      status: 'In Progress',
      advancePaid: 2000,
      balanceDue: 3000,
    ),
    Project(
      projectTitle: 'Project Beta',
      clientName: 'Client B',
      deliveryDate: DateTime.now().add(Duration(days: 5)),
      status: 'Pending',
      advancePaid: 1500,
      balanceDue: 2500,
    ),
    // Add more projects as needed
  ];

  // Example data
  final List<Map<String, dynamic>> projects = [
    {
      'clientName': 'Client A',
      'projectTitle': 'Project Alpha',
      'deliveryDate': DateTime.now().add(Duration(days: 5)),
      'status': 'In Progress',
      'advancePaid': 1000,
      'balanceDue': 500,
    },
    {
      'clientName': 'Client B',
      'projectTitle': 'Project Beta',
      'deliveryDate': DateTime.now().add(Duration(days: 10)),
      'status': 'Pending',
      'advancePaid': 2000,
      'balanceDue': 1000,
    },
    // Add more project data here
  ];

  String searchText = '';
  String selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProjects = projects
        .where((project) =>
            project['clientName']
                .toLowerCase()
                .contains(searchText.toLowerCase()) &&
            (selectedStatus.isEmpty || project['status'] == selectedStatus))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Project List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by client name or project title',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            // Dropdown for status filter
            DropdownButton<String>(
              value: selectedStatus.isEmpty ? null : selectedStatus,
              hint: Text('Filter by Status'),
              onChanged: (String? value) {
                setState(() {
                  selectedStatus = value ?? '';
                });
              },
              items: ['', 'Pending', 'In Progress', 'Completed']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.isEmpty ? 'All' : status),
                      ))
                  .toList(),
            ),
            // List of projects
            Expanded(
              child: ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailScreen(project: projectss[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                          '${project['projectTitle']} - ${project['clientName']}'),
                      subtitle: Text(
                          'Delivery: ${DateFormat('MMM d, yyyy').format(project['deliveryDate'])}'),
                      trailing: Text(project['status']),
                      onTap: () {
                        // Navigate to project details or payment record page
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
