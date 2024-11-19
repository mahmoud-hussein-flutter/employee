// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeModelAdapter extends TypeAdapter<EmployeeModel> {
  @override
  final int typeId = 0;

  @override
  EmployeeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeModel(
      id: fields[0] as int?,
      name: fields[1] as String,
      position: fields[2] as String,
      department: fields[3] as String,
      businessCardImage: fields[4] as String,
      nationalIdImage: fields[5] as String,
      signedContract: fields[6] as String,
      qualifications: fields[7] as String,
      healthSpecialistCert: fields[8] as String,
      cprCourse: fields[9] as String,
      leaveRequest: fields[10] as String,
      returnFromLeave: fields[11] as String,
      businessCardExpirationDate: fields[12] as String,
      nationalIdExpirationDate: fields[13] as String,
      contractExpirationDate: fields[14] as String,
      qualificationsExpirationDate: fields[15] as String,
      healthSpecialistCertExpirationDate: fields[16] as String,
      cprCourseExpirationDate: fields[17] as String,
      leaveRequestExpirationDate: fields[18] as String,
      returnFromLeaveExpirationDate: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.department)
      ..writeByte(4)
      ..write(obj.businessCardImage)
      ..writeByte(5)
      ..write(obj.nationalIdImage)
      ..writeByte(6)
      ..write(obj.signedContract)
      ..writeByte(7)
      ..write(obj.qualifications)
      ..writeByte(8)
      ..write(obj.healthSpecialistCert)
      ..writeByte(9)
      ..write(obj.cprCourse)
      ..writeByte(10)
      ..write(obj.leaveRequest)
      ..writeByte(11)
      ..write(obj.returnFromLeave)
      ..writeByte(12)
      ..write(obj.businessCardExpirationDate)
      ..writeByte(13)
      ..write(obj.nationalIdExpirationDate)
      ..writeByte(14)
      ..write(obj.contractExpirationDate)
      ..writeByte(15)
      ..write(obj.qualificationsExpirationDate)
      ..writeByte(16)
      ..write(obj.healthSpecialistCertExpirationDate)
      ..writeByte(17)
      ..write(obj.cprCourseExpirationDate)
      ..writeByte(18)
      ..write(obj.leaveRequestExpirationDate)
      ..writeByte(19)
      ..write(obj.returnFromLeaveExpirationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
