import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/excel_service/excel_export.dart';
import 'package:tbc_application/app/excel_service/excel_import.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';
import 'package:tbc_application/company_data.dart';

class UsersController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final collection = 'employee';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Employee user = Employee.empty();

  final headers = [
    'ID',
    'Employee ID',
    'Full Name',
    'Email',
    'Phone Number',
    'Job',
    'Role',
    'Created At',
  ];

  @override
  onClose() {
    idC.dispose();
    nameC.dispose();
    emailC.dispose();
  }
  void toggleLoading() => isLoading.toggle();
  RxBool isLoading = false.obs;

  Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  RxBool isLoadingCreatePegawai = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController idC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController mobileC = TextEditingController();
  TextEditingController jobC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> loadUsers() async* {
  //   yield ;
  // }
 
  
  void changeSelectedRole(UserRole? role) {
    selectedRole.value = role;
    // استيراد البيانات من ملف Excel
  }

  void importFromExcel() async {
    print('start importing from excel');
    ImportController<Employee> import = ImportController<Employee>(
      headers: headers,
      fromCsvRow: (Map<String, dynamic> data) {
        return Employee(
          id: data['ID'] == '' ? null : "${data['ID']}",
          employeeId: "${data['Employee ID']}",
          fullname: "${data['Full Name']}",
          email: "${data['Email']}",
          phoneNumber: "${data['Phone Number']}",
          job: "${data['Job']}",
          role: UserRole.set("${data['Role']}"),
          createdAt: "${data['Created At'] ?? DateTime.now().toIso8601String()}",
        );
      },
    );

    List<Employee> employees = await import.importFromFile();

    int index = 1;
    for(Employee employee in employees) {
      print(employee.toMap());
      index += 1;
    }
    bulkAddEditUsers(employees);
    
  }

  Future<void> bulkAddEditUsers(List<Employee> employees) async {
    final batch = firestore.batch();
    final usersCollection = firestore.collection(collection);

    final newUsers = <Employee>[];
    final updates = <Employee>[];

    // Separate new vs existing users
    for (var user in employees) {
      if (user.isCreated()) {
        updates.add(user);
      } else {
        newUsers.add(user);
      }
    }

    try {
      // Prepare account creation in parallel
      final List<Future<Employee>> accountCreations = newUsers.map((e) async {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: e.email!,
          password: CompanyData.defaultPassword, // Replace with secure flow
        );

        final uid = cred.user!.uid;
        return e.copyWith(id: uid, createdAt: DateTime.now().toIso8601String());
      }).toList();

      final createdUsers = await Future.wait(accountCreations);

      // Begin Firestore transaction
      await firestore.runTransaction((txn) async {
        for (var user in updates) {
          final docRef = usersCollection.doc(user.id);
          txn.set(docRef, user.toMap(), SetOptions(merge: true));
        }

        for (var user in createdUsers) {
          final docRef = usersCollection.doc(user.id);
          txn.set(docRef, user.toMap());
        }
      });

      CustomToast.successToast('Success', 'Bulk update complete.');
    } catch (e) {
      CustomToast.errorToast('Error', 'Bulk update failed: ${e.toString()}');
    }
  }

  void exportToExcel() async {
    ExportController<Employee> export = ExportController<Employee>(
      headers: headers,
      toCsvRow: (Employee employee) => [
        employee.id ?? '',
        employee.employeeId ?? '',
        employee.fullname ?? '',
        employee.email ?? '',
        employee.phoneNumber ?? '',
        employee.job ?? '',
        employee.role.value,
        employee.createdAt ?? '',
      ],
    );

    final employees = await firestore.collection(collection).get();
    
    List<Employee> data = employees.docs
        .map((doc) => Employee.fromMap(doc.id, doc.data()))
        .toList();

    await export.exportToCsv(
      data,
      'users.csv',
    );
  }

  void openUserForm(Employee? employee) async {
    user = employee ?? Employee.empty();
    idC.text = user.employeeId ?? '';
    nameC.text = user.fullname ?? '';
    emailC.text = user.email ?? '';
    mobileC.text = user.phoneNumber ?? '';
    jobC.text = user.job ?? '';
    
    Get.toNamed(Routes.ADD_USER);
  }

  void deleteUser(Employee user){
    firestore.collection(collection).doc(user.id).delete().then((value) {
      CustomToast.successToast('Success', 'success deleting an employee');
    }).catchError((error) {
      CustomToast.errorToast('Error', 'error deleting an employee: ${error.toString()}');
    });
  }

  void checkSave() {
    if (!isLoading.value) {
      toggleLoading();
      final isValid = formKey.currentState!.validate();

      if (!isValid) {
        toggleLoading();
        return;
      }

      formKey.currentState!.save();
      addEditUser();
    }
  }

  Future<void> addEditUser() async {
    final isCreated = user.isCreated();
    final docRef = firestore.collection(collection).doc(user.id);

    user = Employee(
      id: isCreated ? user.id : docRef.id,
      employeeId: user.employeeId,
      fullname: user.fullname,
      email: user.email,
      phoneNumber: user.phoneNumber,
      role: user.role,
      job: user.job,
      createdAt: user.createdAt ?? DateTime.now().toIso8601String(),
    );

    try {
      if (!isCreated) {
        // Create Firebase Auth account with default password
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!,
          password: CompanyData.defaultPassword, // Use a secure method to generate or collect real passwords
        );

        // Optionally, update Firestore doc with the Firebase UID
        user = user.copyWith(id: userCredential.user!.uid);
      }

      await firestore.collection(collection).doc(user.id).set(user.toMap(), SetOptions(merge: true));

      Get.back();
      CustomToast.successToast('Success', isCreated ? 'Employee updated' : 'Employee created');
    } catch (e) {
      Get.back();
      CustomToast.errorToast('Error', 'Error saving employee: ${e.toString()}');
    } finally {
      toggleLoading();
    }
  }

  createEmployeeData() async {
    isLoadingCreatePegawai.value = true;
    // String adminEmail = auth.currentUser!.email!;
      try {
            
        // user = user ?? UsersEmployee(employee: Employee(role: UserRole.admin));
        // // user!.employeeId = idC.text ;
        // employee.fullname = nameC.text ;
        // employee.email = emailC.text ;

        // await user!.save();

        // loadUsers();
        
        Get.back(); //close dialog
        CustomToast.successToast('Success', 'success adding an employee');

        isLoadingCreatePegawai.value = false;
        
      } on FirebaseAuthException catch (e) {
        isLoadingCreatePegawai.value = false;
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          CustomToast.errorToast('Error', 'default password too short');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          CustomToast.errorToast('Error', 'Employee already exist');
        } else if (e.code == 'wrong-password') {
          CustomToast.errorToast('Error', 'wrong passowrd');
        } else {
          CustomToast.errorToast('Error', 'error : ${e.code}');
        }
      } catch (e) {
        isLoadingCreatePegawai.value = false;
        CustomToast.errorToast('Error', 'error : ${e.toString()}');
      }

  }
}
