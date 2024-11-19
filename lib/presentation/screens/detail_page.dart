import 'dart:io';
import 'package:flutter/material.dart';
import 'package:employee/data/models/employee_model.dart';
import 'package:hive/hive.dart';
import 'package:employee/presentation/screens/edit_employee_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class DetailPage extends StatefulWidget {
  final int employeeIndex;

  const DetailPage({super.key, required this.employeeIndex});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Box<EmployeeModel> employeesBox;
  EmployeeModel? employee;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  // Load employee data from Hive
  Future<void> _loadEmployeeData() async {
    employeesBox = await Hive.openBox<EmployeeModel>('employees');
    setState(() {
      employee = employeesBox.getAt(widget.employeeIndex);
      _nameController.text =
          employee?.name ?? ''; // Initialize controller with employee name
    });
  }

  // Resolve and validate file path
  String _resolvePath(String filePath) {
    // For Windows paths, replace backslashes with forward slashes
    if (!filePath.startsWith('file://')) {
      filePath = 'file:///' + filePath.replaceAll(r'\\', '/');
    }
    return filePath;
  }

  // Open file based on its type
  Future<void> _openFile(String filePath) async {
    try {
      final resolvedPath = _resolvePath(filePath);
      final fileUri = Uri.parse(resolvedPath);

      // Check if the file exists
      final file = File(filePath);
      if (await file.exists()) {
        if (await canLaunchUrl(fileUri)) {
          await launchUrl(fileUri);
        } else {
          throw 'No application available to open this file.';
        }
      } else {
        throw 'File does not exist at $filePath';
      }
    } catch (e) {
      print("Error opening file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening file: $e")),
      );
    }
  }

  // Pick file and save to employee folder
  Future<void> _pickFile(TextEditingController controller, String fieldName,
      dynamic fieldName_) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      // Get the employee name to create the directory
      String employeeName = _nameController.text.replaceAll(' ', '_');
      String employeeDirPath = path.join('C:', 'employees', employeeName);

      // Check if the folder exists, if not, create it
      final directory = Directory(employeeDirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Safely join the file name with the path
      String newPath =
          path.join(employeeDirPath, '$fieldName_${path.basename(file.path)}');

      // Copy the file to the new location
      await file.copy(newPath);

      // Update the controller with the new file path
      setState(() {
        controller.text = newPath;
      });
    }
  }

  // Determine file icon based on extension
  IconData _getFileIcon(String filePath) {
    if (filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.png')) {
      return Icons.image;
    } else if (filePath.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (filePath.endsWith('.txt')) {
      return Icons.text_snippet;
    } else {
      return Icons.insert_drive_file;
    }
  }

  // Check if the document is expired
  bool _isExpired(String? expirationDate) {
    if (expirationDate == null) return false;
    try {
      // Parse date in DD/MM/YYYY format
      final parts = expirationDate.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final expiry = DateTime(year, month, day);
        return expiry.isBefore(DateTime.now());
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (employee == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Employee Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionTitle('Personal Information'),
              _buildInfoRow('Name', employee!.name),
              _buildInfoRow('Position', employee!.position),
              _buildInfoRow('Department', employee!.department),
              const SizedBox(height: 24),
              const Divider(color: Colors.blueGrey, thickness: 1.2),
              const SizedBox(height: 24),
              // Documents Section
              _buildSectionTitle('Documents'),
              _buildDocumentList(),
              const SizedBox(height: 24),
              // Edit Employee Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEmployeePage(
                            employeeIndex: widget
                                .employeeIndex), // Pass employeeIndex here
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Edit Employee',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey[700],
            ),
          ),
          Flexible(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    List<Map<String, String?>> documents = [
      {
        "name": "Business Card Image",
        "file": employee?.businessCardImage,
        "expiration": employee?.businessCardExpirationDate,
      },
      {
        "name": "National ID Image",
        "file": employee?.nationalIdImage,
        "expiration": employee?.nationalIdExpirationDate,
      },
      {
        "name": "Signed Contract",
        "file": employee?.signedContract,
        "expiration": employee?.contractExpirationDate,
      },
      {
        "name": "Qualifications",
        "file": employee?.qualifications,
        "expiration": employee?.qualificationsExpirationDate,
      },
      {
        "name": "Health Specialist Certification",
        "file": employee?.healthSpecialistCert,
        "expiration": employee?.healthSpecialistCertExpirationDate,
      },
      // New Documents
      {
        "name": "CPR Course",
        "file": employee?.cprCourse,
        "expiration": employee?.cprCourseExpirationDate,
      },
      {
        "name": "Leave Request",
        "file": employee?.leaveRequest,
        "expiration": employee?.leaveRequestExpirationDate,
      },
      {
        "name": "Return from Leave",
        "file": employee?.returnFromLeave,
        "expiration": employee?.returnFromLeaveExpirationDate,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        final file = doc['file'] ?? '';
        final expiration = doc['expiration'];
        final isExpired = _isExpired(expiration);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Icon(
                file.isNotEmpty ? _getFileIcon(file) : Icons.warning,
                size: 40,
                color: file.isNotEmpty
                    ? (isExpired ? Colors.red : Colors.blueGrey)
                    : Colors.grey,
              ),
              title: Text(
                doc['name'] ?? 'Unknown Document',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              subtitle: Text(
                expiration != null
                    ? 'Expiration Date: $expiration'
                    : 'No expiration date provided.',
                style: TextStyle(
                  color: isExpired ? Colors.red : Colors.blueGrey[600],
                ),
              ),
              trailing: file.isNotEmpty
                  ? const Icon(Icons.open_in_new, color: Colors.blueGrey)
                  : const Icon(Icons.error, color: Colors.grey),
              onTap: file.isNotEmpty
                  ? () {
                      _openFile(file);
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("File not available"),
                        ),
                      );
                    },
            ),
          ),
        );
      },
    );
  }
}
