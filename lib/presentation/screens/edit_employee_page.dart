import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:employee/data/models/employee_model.dart';
import 'package:employee/presentation/screens/home_page.dart';

class EditEmployeePage extends StatefulWidget {
  final int employeeIndex;
  const EditEmployeePage({Key? key, required this.employeeIndex})
      : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _businessCardController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _contractController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _cprCourseController = TextEditingController();
  final TextEditingController _leaveRequestController = TextEditingController();
  final TextEditingController _returnFromLeaveController =
      TextEditingController();

  // Expiration date controllers for each document
  final TextEditingController _businessCardExpirationController =
      TextEditingController();
  final TextEditingController _nationalIdExpirationController =
      TextEditingController();
  final TextEditingController _contractExpirationController =
      TextEditingController();
  final TextEditingController _qualificationExpirationController =
      TextEditingController();
  final TextEditingController _specializationExpirationController =
      TextEditingController();
  final TextEditingController _cprCourseExpirationController =
      TextEditingController();
  final TextEditingController _leaveRequestExpirationController =
      TextEditingController();
  final TextEditingController _returnFromLeaveExpirationController =
      TextEditingController();

  // Password controllers
  final TextEditingController _passwordController = TextEditingController();
  final String _adminPassword = "admin123";

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  // Load employee data from Hive
  Future<void> _loadEmployeeData() async {
    final employeeBox = await Hive.openBox<EmployeeModel>('employees');
    final employee = employeeBox.getAt(widget.employeeIndex);

    if (employee != null) {
      _nameController.text = employee.name;
      _positionController.text = employee.position;
      _departmentController.text = employee.department;
      _businessCardController.text = employee.businessCardImage;
      _nationalIdController.text = employee.nationalIdImage;
      _contractController.text = employee.signedContract;
      _qualificationController.text = employee.qualifications;
      _specializationController.text = employee.healthSpecialistCert;
      _cprCourseController.text = employee.cprCourse;
      _leaveRequestController.text = employee.leaveRequest;
      _returnFromLeaveController.text = employee.returnFromLeave;
      _businessCardExpirationController.text =
          employee.businessCardExpirationDate;
      _nationalIdExpirationController.text = employee.nationalIdExpirationDate;
      _contractExpirationController.text = employee.contractExpirationDate;
      _qualificationExpirationController.text =
          employee.qualificationsExpirationDate;
      _specializationExpirationController.text =
          employee.healthSpecialistCertExpirationDate;
      _cprCourseExpirationController.text = employee.cprCourseExpirationDate;
      _leaveRequestExpirationController.text =
          employee.leaveRequestExpirationDate;
      _returnFromLeaveExpirationController.text =
          employee.returnFromLeaveExpirationDate;
    }
  }

  // File picker function
  Future<void> _pickFile(
      TextEditingController controller, String fieldName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String employeeName = _nameController.text.replaceAll(' ', '_');
      String employeeDirPath = 'C:/employees/$employeeName';

      final directory = Directory(employeeDirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      String newPath =
          '$employeeDirPath/${fieldName}_${file.uri.pathSegments.last}';
      await file.copy(newPath);

      setState(() {
        controller.text = newPath;
      });
    }
  }

  // Delete employee from Hive
  Future<void> _deleteEmployeeFromHive() async {
    final employeeBox = await Hive.openBox<EmployeeModel>('employees');

    if (_passwordController.text == _adminPassword) {
      await employeeBox.deleteAt(widget.employeeIndex);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee deleted successfully!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Incorrect password. Cannot delete employee.")),
      );
    }
  }

  // Date picker for expiration dates
  Future<void> _pickExpirationDate(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Build text field for form inputs
  Widget _buildTextField(
      String label, IconData prefixIcon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
          labelStyle: const TextStyle(color: Colors.blueGrey),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Update employee data in Hive
  Future<void> _updateEmployeeInHive() async {
    if (_passwordController.text != _adminPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Incorrect password. Cannot save changes.")),
      );
      return;
    }

    final employeeBox = await Hive.openBox<EmployeeModel>('employees');
    final updatedEmployee = EmployeeModel(
      name: _nameController.text,
      position: _positionController.text,
      department: _departmentController.text,
      businessCardImage: _businessCardController.text,
      nationalIdImage: _nationalIdController.text,
      signedContract: _contractController.text,
      qualifications: _qualificationController.text,
      healthSpecialistCert: _specializationController.text,
      cprCourse: _cprCourseController.text,
      leaveRequest: _leaveRequestController.text,
      returnFromLeave: _returnFromLeaveController.text,
      businessCardExpirationDate: _businessCardExpirationController.text,
      nationalIdExpirationDate: _nationalIdExpirationController.text,
      contractExpirationDate: _contractExpirationController.text,
      qualificationsExpirationDate: _qualificationExpirationController.text,
      healthSpecialistCertExpirationDate:
          _specializationExpirationController.text,
      cprCourseExpirationDate: _cprCourseExpirationController.text,
      leaveRequestExpirationDate: _leaveRequestExpirationController.text,
      returnFromLeaveExpirationDate: _returnFromLeaveExpirationController.text,
    );

    await employeeBox.putAt(widget.employeeIndex, updatedEmployee);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Employee updated successfully!")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: BackButton(color: Colors.white),
          title: const Text(
            'Edit Employee',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Employee Name', Icons.person, _nameController),
                _buildTextField('Position', Icons.work, _positionController),
                _buildTextField(
                    'Department', Icons.business, _departmentController),
                _buildTextField('Password', Icons.lock, _passwordController),

                const SizedBox(height: 20), // Add space between sections

                const Text('Documents',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                _buildTextField(
                    'Business Card', Icons.business, _businessCardController),
                _buildTextField('Business Card Expiry', Icons.calendar_today,
                    _businessCardExpirationController),
                const SizedBox(height: 10),
                _buildTextField('National ID', Icons.card_membership,
                    _nationalIdController),
                _buildTextField('National ID Expiry', Icons.calendar_today,
                    _nationalIdExpirationController),
                const SizedBox(height: 10),
                _buildTextField(
                    'Contract', Icons.file_copy, _contractController),
                _buildTextField('Contract Expiry', Icons.calendar_today,
                    _contractExpirationController),
                const SizedBox(height: 10),
                _buildTextField(
                    'Qualification', Icons.school, _qualificationController),
                _buildTextField('Qualification Expiry', Icons.calendar_today,
                    _qualificationExpirationController),
                const SizedBox(height: 10),
                _buildTextField('Specialization', Icons.medical_services,
                    _specializationController),
                _buildTextField('Specialization Expiry', Icons.calendar_today,
                    _specializationExpirationController),
                const SizedBox(height: 10),
                _buildTextField(
                    'CPR Course', Icons.local_hospital, _cprCourseController),
                _buildTextField('CPR Course Expiry', Icons.calendar_today,
                    _cprCourseExpirationController),
                const SizedBox(height: 10),
                _buildTextField('Leave Request', Icons.exit_to_app,
                    _leaveRequestController),
                _buildTextField('Leave Request Expiry', Icons.calendar_today,
                    _leaveRequestExpirationController),
                const SizedBox(height: 10),
                _buildTextField('Return From Leave', Icons.replay,
                    _returnFromLeaveController),
                _buildTextField('Return From Leave Expiry',
                    Icons.calendar_today, _returnFromLeaveExpirationController),

                const SizedBox(height: 30),

                // Save and Delete Buttons with improved UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updateEmployeeInHive,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _deleteEmployeeFromHive,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Delete',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
