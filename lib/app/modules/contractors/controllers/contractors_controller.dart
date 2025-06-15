import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/contractors/models/contractors.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class ContractorsController extends GetxController {
  @override
  onClose() {
    idC.dispose();
    nameC.dispose();
    emailC.dispose();
  }

  RxBool isLoading = false.obs;
  RxBool isLoadingCreatePegawai = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  var contractors = <Contractor>[].obs;

  Contractor? contractor;

  TextEditingController idC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadContractors();
  }

 void loadContractors() async {
    List<Contractor> items = await Contractor(employee: Employee(id: '', role: UserRole.contractor)).get();
    contractors.value = items;
  }
 
  void deleteContractor(Contractor contractor){
    contractor.delete();
    loadContractors();
  }
  
  void importFromExcel() {
    // استيراد البيانات من ملف Excel
  }

  void exportToExcel() {
    // تصدير البيانات إلى ملف Excel
  }

  void openContractorForm(Contractor? contractor) async {
    contractor = contractor ?? Contractor(employee: Employee(id: '', role: UserRole.contractor));
    
    idC.text = contractor.employeeId ?? '';
    nameC.text = contractor.employee.fullname ?? '';
    emailC.text = contractor.employee.email ?? '';

    Get.toNamed(Routes.ADD_CONTRACTOR);
  }

  Future<void> addContractor() async {
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
            
        contractor = contractor ?? Contractor(employee: Employee(id: '', role: UserRole.contractor));
        contractor!.employeeId = idC.text ;
        contractor!.employee.fullname = nameC.text ;
        contractor!.employee.email = emailC.text ;

        await contractor!.save();

        loadContractors();
        
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
