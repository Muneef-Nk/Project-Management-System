import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  // Controllers for TextFields
  final _clientNameController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _deliveryDate;
  DateTime? _paymentDueDate;
  String? _status;
  final List<String> _statusOptions = ['Pending', 'In Progress', 'Completed'];

  @override
  void dispose() {
    _clientNameController.dispose();
    _projectTitleController.dispose();
    _projectDescriptionController.dispose();
    _totalAmountController.dispose();
    _advanceAmountController.dispose();
    super.dispose();
  }

  // Method to calculate balance amount
  String get balanceAmount {
    double total = double.tryParse(_totalAmountController.text) ?? 0;
    double advance = double.tryParse(_advanceAmountController.text) ?? 0;
    return (total - advance).toStringAsFixed(2);
  }

  // Method to pick a date

  Future<void> _pickDate(
      BuildContext context, Function(DateTime) onDatePicked) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    // Check if the widget is still mounted before calling setState
    if (selectedDate != null && mounted) {
      onDatePicked(selectedDate);
    }
  }

  // Validation method
  bool _validateFields() {
    return _clientNameController.text.isNotEmpty &&
        _projectTitleController.text.isNotEmpty &&
        _projectDescriptionController.text.isNotEmpty &&
        _startDate != null &&
        _deliveryDate != null &&
        _totalAmountController.text.isNotEmpty &&
        _advanceAmountController.text.isNotEmpty &&
        _paymentDueDate != null &&
        _status != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Client Name Input
            TextField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
            ),
            // Project Title Input
            TextField(
              controller: _projectTitleController,
              decoration: InputDecoration(labelText: 'Project Title'),
            ),
            // Project Description Input
            TextField(
              controller: _projectDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Project Description'),
            ),
            // Start Date Picker
            ListTile(
              title: Text(
                _startDate == null
                    ? 'Select Start Date'
                    : DateFormat('MMM d, yyyy').format(_startDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDate(context, (date) {
                setState(() {
                  _startDate = date;
                });
              }),
            ),
            // Delivery Date Picker
            ListTile(
              title: Text(
                _deliveryDate == null
                    ? 'Select Delivery Date'
                    : DateFormat('MMM d, yyyy').format(_deliveryDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDate(context, (date) {
                setState(() {
                  _deliveryDate = date;
                });
              }),
            ),
            // Total Project Amount Input
            TextField(
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Project Amount'),
            ),
            // Advance Amount Paid Input
            TextField(
              controller: _advanceAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Advance Amount Paid'),
              onChanged: (value) => setState(() {}),
            ),
            // Balance Amount Due (Auto-Calculated)
            ListTile(
              title: Text('Balance Amount Due: \$${balanceAmount}'),
            ),
            // Payment Due Date Picker
            ListTile(
              title: Text(
                _paymentDueDate == null
                    ? 'Select Payment Due Date'
                    : DateFormat('MMM d, yyyy').format(_paymentDueDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDate(context, (date) {
                setState(() {
                  _paymentDueDate = date;
                });
              }),
            ),
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _status,
              hint: Text('Select Status'),
              onChanged: (String? value) {
                setState(() {
                  _status = value;
                });
              },
              items: _statusOptions
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
            // Submit Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                  // Handle form submission
                } else {
                  // Show validation error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                }
              },
              child: Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }
}
