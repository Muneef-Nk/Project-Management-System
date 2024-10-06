import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management_system/core/color/color_constants.dart';
import 'package:project_management_system/core/global/helper_function.dart';
import 'package:project_management_system/core/utils/loading.dart';
import 'package:project_management_system/features/project_list/model/project_list_model.dart';
import 'package:project_management_system/features/project_list/widgets/project_container.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String searchQuery = '';

  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  void searchProjects(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: AppColor.primary,
        title: Text(
          'Project List',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColor.white,
            ),
            onPressed: () {
              //
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: boxDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppColor.grey),
                ),
                onChanged: (value) {
                  searchProjects(value);
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: projects.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Loading(
                      color: AppColor.primary,
                    ));
                  }

                  var projectDocs = snapshot.data!.docs;

                  var projectModels = projectDocs.map((doc) {
                    return ProjectListModel.fromFirestore(
                        doc.data() as Map<String, dynamic>, doc.id);
                  }).toList();

                  var filteredProjects = projectModels.where((project) {
                    return project.name.toLowerCase().contains(searchQuery) ||
                        project.status.toLowerCase().contains(searchQuery);
                  }).toList();

                  if (filteredProjects.isEmpty) {
                    return Center(
                        child: Text(
                      'No project found',
                      style: TextStyle(color: AppColor.grey, fontSize: 12),
                    ));
                  }

                  return ListView.builder(
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      var project = filteredProjects[index];
                      return ProjectContainer(project: project);
                    },
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
