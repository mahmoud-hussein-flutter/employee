import 'package:hive/hive.dart';

part 'employee_model.g.dart'; // This will reference the generated file

@HiveType(typeId: 0) // Set a unique typeId for each model.
class EmployeeModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  String name; // Changed from final to mutable

  @HiveField(2)
  String position; // Changed from final to mutable

  @HiveField(3)
  String department; // Changed from final to mutable

  @HiveField(4)
  String businessCardImage; // Changed from final to mutable

  @HiveField(5)
  String nationalIdImage; // Changed from final to mutable

  @HiveField(6)
  String signedContract; // Changed from final to mutable

  @HiveField(7)
  String qualifications; // Changed from final to mutable

  @HiveField(8)
  String healthSpecialistCert; // Changed from final to mutable

  @HiveField(9)
  String cprCourse; // Changed from final to mutable

  @HiveField(10)
  String leaveRequest; // Changed from final to mutable

  @HiveField(11)
  String returnFromLeave; // Changed from final to mutable

  @HiveField(12)
  String businessCardExpirationDate; // Changed from final to mutable

  @HiveField(13)
  String nationalIdExpirationDate; // Changed from final to mutable

  @HiveField(14)
  String contractExpirationDate; // Changed from final to mutable

  @HiveField(15)
  String qualificationsExpirationDate; // Changed from final to mutable

  @HiveField(16)
  String healthSpecialistCertExpirationDate; // Changed from final to mutable

  @HiveField(17)
  String cprCourseExpirationDate; // Changed from final to mutable

  @HiveField(18)
  String leaveRequestExpirationDate; // Changed from final to mutable

  @HiveField(19)
  String returnFromLeaveExpirationDate; // Changed from final to mutable

  EmployeeModel({
    this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.businessCardImage,
    required this.nationalIdImage,
    required this.signedContract,
    required this.qualifications,
    required this.healthSpecialistCert,
    required this.cprCourse,
    required this.leaveRequest,
    required this.returnFromLeave,
    required this.businessCardExpirationDate,
    required this.nationalIdExpirationDate,
    required this.contractExpirationDate,
    required this.qualificationsExpirationDate,
    required this.healthSpecialistCertExpirationDate,
    required this.cprCourseExpirationDate,
    required this.leaveRequestExpirationDate,
    required this.returnFromLeaveExpirationDate,
  });
}
