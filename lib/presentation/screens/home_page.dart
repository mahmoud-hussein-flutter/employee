import 'package:flutter/material.dart';
import 'package:employee/data/models/employee_model.dart';
import 'package:hive/hive.dart';
import 'package:employee/presentation/screens/detail_page.dart';
import 'package:employee/presentation/screens/add_employee_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EmployeeModel> employees = [];
  List<EmployeeModel> filteredEmployees = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployees();

    // Listen to search input changes
    _searchController.addListener(() {
      filterEmployees();
    });
  }

  // Load employees from Hive box
  Future<void> _loadEmployees() async {
    final employeesBox = await Hive.openBox<EmployeeModel>('employees');
    setState(() {
      employees = employeesBox.values.toList();
      filteredEmployees = employees;
    });
  }

  // Filter employees based on search term
  void filterEmployees() {
    setState(() {
      String searchTerm = _searchController.text.toLowerCase();
      filteredEmployees = employees.where((employee) {
        return employee.name.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  leading: BackButton(
     color: Colors.white
   ), 
        title: const Text(
          'Employee Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // List of Employees
            Expanded(
              child: filteredEmployees.isEmpty
                  ? const Center(child: Text("No employees found"))
                  : ListView.builder(
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                            title: Text(
                              employee.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${employee.position}\n${employee.department}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.blueGrey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(employeeIndex: index),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeePage()),
          ).then((_) {
            // Reload employee data after adding a new employee
            _loadEmployees();
          });
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
