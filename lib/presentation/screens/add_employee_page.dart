import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:employee/data/models/employee_model.dart';
import 'package:employee/presentation/screens/home_page.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _businessCardController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _contractController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _cprCourseController = TextEditingController();
  final TextEditingController _leaveRequestController = TextEditingController();
  final TextEditingController _returnFromLeaveController = TextEditingController();

  // Expiration date controllers
  final TextEditingController _businessCardExpirationController = TextEditingController();
  final TextEditingController _nationalIdExpirationController = TextEditingController();
  final TextEditingController _contractExpirationController = TextEditingController();
  final TextEditingController _qualificationExpirationController = TextEditingController();
  final TextEditingController _specializationExpirationController = TextEditingController();
  final TextEditingController _cprCourseExpirationController = TextEditingController();
  final TextEditingController _leaveRequestExpirationController = TextEditingController();
  final TextEditingController _returnFromLeaveExpirationController = TextEditingController();

  // Function to pick a file
  Future<void> _pickFile(TextEditingController controller, String fieldName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      // Get the employee name to create the directory
      String employeeName = _nameController.text.replaceAll(' ', '_');
      String employeeDirPath = 'C:/employees/$employeeName';

      // Check if the folder exists, if not, create it
      final directory = Directory(employeeDirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Create a copy of the file in the employee's folder
      String newPath = '$employeeDirPath/${fieldName}_${file.uri.pathSegments.last}';
      await file.copy(newPath);

      // Update the controller with the new file path
      setState(() {
        controller.text = newPath;
      });
    }
  }

  // Builds a text field with icons and validation
  Widget _buildTextField(String label, IconData prefixIcon, TextEditingController controller) {
    return TextFormField(
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
    );
  }

  // Function to build file picker with expiration date input
  Widget _buildFilePicker(
    String label,
    IconData prefixIcon,
    TextEditingController controller,
    TextEditingController expirationController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickFile(controller, label),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(prefixIcon, color: Colors.blueAccent),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.blueAccent),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                          });
                        },
                      )
                    : const Icon(Icons.attach_file, color: Colors.blueAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
                labelStyle: const TextStyle(color: Colors.blueGrey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'File is required';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: expirationController,
          decoration: InputDecoration(
            labelText: '$label Expiration Date',
            prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
            labelStyle: const TextStyle(color: Colors.blueGrey),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Expiration date is required';
            }
            return null;
          },
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              expirationController.text =
                  "${date.day}/${date.month}/${date.year}";
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Function to add employee data to Hive
  Future<void> _addEmployeeToHive() async {
    final employeesBox = await Hive.openBox<EmployeeModel>('employees');

    final newEmployee = EmployeeModel(
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
      healthSpecialistCertExpirationDate: _specializationExpirationController.text,
      cprCourseExpirationDate: _cprCourseExpirationController.text,
      leaveRequestExpirationDate: _leaveRequestExpirationController.text,
      returnFromLeaveExpirationDate: _returnFromLeaveExpirationController.text,
    );

    await employeesBox.add(newEmployee);

    // After adding employee, navigate to the DetailPage to view the new employee details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(), // Pass the index
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Employee added to Hive successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(
     color: Colors.white
   ), 
        title: const Text('Add Employee',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Employee Name", Icons.person, _nameController),
                const SizedBox(height: 20),
                _buildTextField("Job Title", Icons.work, _positionController),
                const SizedBox(height: 20),
                _buildTextField("Department", Icons.business, _departmentController),
                const SizedBox(height: 25),
                // Document Upload Fields with Expiration Dates
                _buildFilePicker("Business Card Image", Icons.business,
                    _businessCardController, _businessCardExpirationController),
                _buildFilePicker("National ID Image", Icons.card_membership,
                    _nationalIdController, _nationalIdExpirationController),
                _buildFilePicker("Signed Contract", Icons.description,
                    _contractController, _contractExpirationController),
                _buildFilePicker(
                    "Qualifications",
                    Icons.school,
                    _qualificationController,
                    _qualificationExpirationController),
                _buildFilePicker(
                    "Health Specialist Certification",
                    Icons.local_hospital,
                    _specializationController,
                    _specializationExpirationController),
                _buildFilePicker("CPR Course", Icons.fitness_center,
                    _cprCourseController, _cprCourseExpirationController),
                _buildFilePicker("Leave Request", Icons.request_page,
                    _leaveRequestController, _leaveRequestExpirationController),
                _buildFilePicker(
                    "Return from Leave",
                    Icons.calendar_today,
                    _returnFromLeaveController,
                    _returnFromLeaveExpirationController),
                const SizedBox(height: 25),
                // Submit Button with Password Prompt
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Show password dialog first
                      _showPasswordDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Add Employee',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPasswordDialog(BuildContext context) async {
    final TextEditingController _passwordController = TextEditingController();

    return showDialog<void>( 
      context: context,
      barrierDismissible: false, // User must enter the password
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String enteredPassword = _passwordController.text;
                if (enteredPassword == '123') {
                  _addEmployeeToHive();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
