import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/supervisors/models/supervisor.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class SupervisorsController extends GetxController {
  @override
  onClose() {
    idC.dispose();
    nameC.dispose();
    emailC.dispose();
  }

  RxBool isLoading = false.obs;
  RxBool isLoadingCreatePegawai = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  var supervisors = <Supervisor>[].obs;

  Supervisor? supervisor;

  TextEditingController idC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadSupervisors();
  }

 void loadSupervisors() async {
    List<Supervisor> items = await Supervisor(employee: Employee(id: '', role: UserRole.supervisor)).get();
    supervisors.value = items;
  }
 
  void deleteSupervisor(Supervisor contractor){
    contractor.delete();
    loadSupervisors();
  }
  
  void importFromExcel() {
    // استيراد البيانات من ملف Excel
  }

  void exportToExcel() {
    // تصدير البيانات إلى ملف Excel
  }

  void openSupervisorForm(Supervisor? supervisor) async {
    supervisor = supervisor ?? Supervisor(employee: Employee(id: '', role: UserRole.supervisor));
    
    idC.text = supervisor.employeeId ?? '';
    nameC.text = supervisor.employee.fullname ?? '';
    emailC.text = supervisor.employee.email ?? '';

    Get.toNamed(Routes.ADD_SUPERVISOR);
  }

  Future<void> addSupervisor() async {
    if (idC.text.isNotEmpty && nameC.text.isNotEmpty && emailC.text.isNotEmpty) {
      isLoading.value = true;
      createEmployeeData();
      isLoading.value = false;
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  createEmployeeData() async {
    isLoadingCreatePegawai.value = true;
    // String adminEmail = auth.currentUser!.email!;
      try {
            
        supervisor = supervisor ?? Supervisor(employee: Employee(id: '', role: UserRole.supervisor));
        supervisor!.employeeId = idC.text ;
        supervisor!.employee.fullname = nameC.text ;
        supervisor!.employee.email = emailC.text ;

        await supervisor!.save();

        loadSupervisors();
        
        Get.back(); //close dialog
        CustomToast.successToast('Success', 'success adding employee');

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
