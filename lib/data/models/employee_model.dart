import 'package:hive/hive.dart';

part 'employee_model.g.dart'; // This will reference the generated file

@HiveType(typeId: 0) // Set a unique typeId for each model.
class EmployeeModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String position;

  @HiveField(3)
  final String department;

  @HiveField(4)
  final String businessCardImage;

  @HiveField(5)
  final String nationalIdImage;

  @HiveField(6)
  final String signedContract;

  @HiveField(7)
  final String qualifications;

  @HiveField(8)
  final String healthSpecialistCert;

  @HiveField(9)
  final String cprCourse;

  @HiveField(10)
  final String leaveRequest;

  @HiveField(11)
  final String returnFromLeave;

  @HiveField(12)
  final String businessCardExpirationDate;

  @HiveField(13)
  final String nationalIdExpirationDate;

  @HiveField(14)
  final String contractExpirationDate;

  @HiveField(15)
  final String qualificationsExpirationDate;

  @HiveField(16)
  final String healthSpecialistCertExpirationDate;

  @HiveField(17)
  final String cprCourseExpirationDate;

  @HiveField(18)
  final String leaveRequestExpirationDate;

  @HiveField(19)
  final String returnFromLeaveExpirationDate;

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
