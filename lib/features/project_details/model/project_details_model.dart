class ProjectDetailsModel {
  final String projectName;
  final String description;
  final String clientName;
  final String startDate;
  final String deliveryDate;
  final String paymentDueDate;
  final String totalAmount;
  final String advancePaid;
  final String status;

  ProjectDetailsModel({
    required this.projectName,
    required this.description,
    required this.clientName,
    required this.startDate,
    required this.deliveryDate,
    required this.paymentDueDate,
    required this.totalAmount,
    required this.advancePaid,
    required this.status,
  });

  factory ProjectDetailsModel.fromFirestore(Map<String, dynamic> data) {
    return ProjectDetailsModel(
      projectName: data['project_name'] as String? ?? '',
      description: data['project_description'] as String? ?? '',
      clientName: data['client_name'] as String? ?? '',
      startDate: data['start_date'] as String? ?? '',
      deliveryDate: data['delivery_date'] as String? ?? '',
      paymentDueDate: data['payment_due_date'] as String? ?? '',
      totalAmount: (data['project_amount'] ?? '0').toString(),
      advancePaid: (data['advance_amount'] ?? '0').toString(),
      status: data['status'] as String? ?? 'Unknown',
    );
  }
}
