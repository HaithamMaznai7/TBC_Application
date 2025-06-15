import 'package:tbc_application/app/modules/uesrs/models/user.dart';

class Employee {
  
  String? id;
  String? employeeId;
  String? fullname;
  String? email;
  String? phoneNumber;
  UserRole role;
  String? job;
  String? avatar;
  String? createdAt;
 
  // Constructor
  Employee({
    this.id,
    this.employeeId,
    this.fullname,
    this.phoneNumber,
    this.email,
    this.job,
    required this.role,
    this.avatar,
    this.createdAt
  });

  Employee copyWith({
    String? id,
    String? employeeId,
    String? fullname,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? job,
    String? createdAt,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      job: job ?? this.job,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Employee fromMap(String id, Map<String, dynamic> data) {
    return Employee(
      id: id,
      employeeId: data['employeeId'],
      fullname: data['fullname'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      job: data['job'],
      role: UserRole.set(data['role']),
      avatar: data['avatar'],
      createdAt: data['createdAt'],
    );
  }

  static Employee empty() {
    return Employee(
      role: UserRole.none,
    );
  }

  bool isCreated() {
    return id != null && id != "";
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role.value,
      'job': job,
      'createdAt': createdAt,
    };
  }
}

enum UserRole { 
  superAdmin,
  admin,
  supervisor,
  contractor,
  none;

  String get label {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.contractor:
        return 'Contractor';
      case UserRole.none:
        return 'none';
    }
  }

  String get value {
    switch (this) {
      case UserRole.superAdmin:
        return 'superAdmin';
      case UserRole.admin:
        return 'admin';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.contractor:
        return 'contractor';
      case UserRole.none:
        return 'none';
    }
  }

  static UserRole set(String? value) {
    switch (value) {
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'admin':
        return UserRole.admin;
      case 'supervisor':
        return UserRole.supervisor;
      case 'contractor':
        return UserRole.contractor;
      case 'none':
        return UserRole.none;
      default:
        return UserRole.none;
    }
  }
}