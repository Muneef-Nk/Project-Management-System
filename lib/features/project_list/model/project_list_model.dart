// project_model.dart

class ProjectListModel {
  final String id;
  final String name;
  final String clientName;
  final String status;
  final DateTime deliveryDate;
  final double advanceAmount;
  final double balance;
  final double total;

  ProjectListModel({
    required this.total,
    required this.id,
    required this.name,
    required this.clientName,
    required this.status,
    required this.deliveryDate,
    required this.advanceAmount,
    required this.balance,
  });

  factory ProjectListModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProjectListModel(
      id: id,
      name: data['project_name'] ?? '',
      clientName: data['client_name'] ?? 'Unknown',
      status: data['status'] ?? 'Pending',
      deliveryDate: DateTime.parse(data['delivery_date']),
      advanceAmount: _toDouble(data['advance_amount']),
      balance: _toDouble(data['balance']),
      total: _toDouble(data['project_amount']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }
}
