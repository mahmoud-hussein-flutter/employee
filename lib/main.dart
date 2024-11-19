import 'package:flutter/material.dart';import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee/presentation/screens/home_page.dart';
import 'package:employee/data/models/employee_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register the adapter
  Hive.registerAdapter(EmployeeModelAdapter());

  // Open the box for storing Employee data
  await Hive.openBox<EmployeeModel>('employees');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
