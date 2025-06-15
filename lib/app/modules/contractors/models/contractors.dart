import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';

class Contractor  extends FbAuth<Contractor> {
  
  @override
  String? id;
  
  @override
  Employee employee;

  String? employeeId;
  // WorkScop workScope = WorkScop.none;

  // Accessories : 
  
  // Constructor
  Contractor({
    this.id,
    this.employeeId,
    required this.employee,  // Make the employee parameter required
    // this.workScope = WorkScop.none,  // default value is none in WorkScop enum  // This is the enum type of workScope field in your Firestore database. You can replace WorkScop.none with the actual enum value.  // For example, if the enum value is 'FULL_TIME', then you should write 'WorkScop.fullTime' instead of 'WorkScop.none' in your code.  // Note: This is just
  }) : super("contractors");

  // Override
  @override
  Contractor fromCollection(String? id, Map<String, dynamic> data, Employee? employee) {
    return Contractor(
      id: id,
      employee: employee ?? Employee(id: '', role: UserRole.contractor),
      employeeId: data['ContractorsId'],
      // workScope: WorkScop.set(data['workScope']),  // This is the enum type of workScope field in your Firestore database. You can replace WorkScop.none with the actual enum value.  // For example, if the enum value is 'FULL_TIME', then you should write 'WorkScop.fullTime' instead of 'WorkScop.none' in your code.  // Note: This is just an example. You may
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      // 'workScope': workScope.label,
    };
  }




}
  