class Project {
  String projectTitle;
  String clientName;
  DateTime deliveryDate;
  String status; // "Pending", "In Progress", "Completed"
  double advancePaid;
  double balanceDue;

  Project({
    required this.projectTitle,
    required this.clientName,
    required this.deliveryDate,
    required this.status,
    required this.advancePaid,
    required this.balanceDue,
  });
}
