import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/assets/models/asset.dart';
import 'package:tbc_application/app/modules/contractors/models/contractors.dart';
import 'package:tbc_application/app/modules/maintenence_types/models/maintenance_type_model.dart';
import 'package:tbc_application/app/modules/school/controllers/school_controller.dart';
import 'package:tbc_application/app/modules/school/views/widgets/base_section.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/util/constants/colors.dart';

class SupervisorsSectionBody extends StatelessWidget {

  final SchoolDetailsController controller;

  const SupervisorsSectionBody(this.controller, {super.key});


  @override
  Widget build(BuildContext context) {
    return BaseSectionCard(
      title: "المشرفين",
      actions: [
        IconButton(onPressed: controller.addSupervisors, icon: Icon(Icons.add, color: Colors.white,))
      ],
      body: Obx(()=> Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
          spacing: 9,
          children: controller.supervisors.map((s) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      controller.supervisors.remove(s);
                    },
                    icon: Icon(Icons.delete)
                  ),
                  Text(s.userID),
                ],
              ),
              Chip(label: Text(s.workScop.label), backgroundColor: FColors.secondary,),
            ]
          )).toList(),
        ),
      ))
    );
  }
}

class WorkScopDialogController extends GetxController {
  Rx<WorkScop> selectedScope = WorkScop.none.obs;
  RxString searchQuery = ''.obs;
  RxString selectedUser = ''.obs;

  var allUsers = <Contractor>[].obs;
  var filteredUsers = <Contractor>[].obs;
  
  @override
  void onInit() {
    // TODO: implement onInit
    loadUsers();
    super.onInit();
  }

  void loadUsers() async {
    allUsers.value = await Contractor(employee: Employee(id: '', role: UserRole.contractor)).get();
    filteredUsers.value = List<Contractor>.from(allUsers);
  }

  void search(String val) {
    searchQuery.value = val;
    
    filteredUsers.value = searchQuery.value.isEmpty
      ? List<Contractor>.from(allUsers)
      : allUsers
          .where((user) =>
              user.employee.fullname!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              user.employeeId!.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
  }
}

class WorkScopDialog extends StatelessWidget{

  const WorkScopDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(WorkScopDialogController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Work Scope & User'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Work Scope:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => Wrap(
              spacing: 8.0,
              children: WorkScop.values
                  .where((e) => e != WorkScop.none)
                  .map((scope) => ChoiceChip(
                        label: Text(scope.label),
                        selected: controller.selectedScope.value == scope,
                        onSelected: (_) => controller.selectedScope.value = scope,
                      ))
                  .toList(),
            )),
            SizedBox(height: 24),
            Text("Search User:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: "Search user name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Obx(() { 
            return controller.filteredUsers.length >= 1 
            ? Expanded(
              child: ListView(
                children: controller.filteredUsers
                    .map((user) => ListTile(
                          title: Text('${user.employee.fullname}'),
                          trailing: controller.selectedUser.value == user.id
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () => controller.selectedUser.value = user.id!,
                        ))
                    .toList(),
              ),
            )
            : SizedBox();
  }),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedScope.value != WorkScop.none 
                  && controller.selectedUser.value.isNotEmpty 
                  // && controller.filteredUsers.contains(
                  //     (element) => element == controller.selectedUser.value
                  //   )
                  ) {
                    Get.back(result: Supervisor(
                      workScop: controller.selectedScope.value,
                      userID: controller.selectedUser.value
                    ));
                  }
                },
                child: Text("Confirm Selection"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MaintenanceTypesDialogController extends GetxController {
  var searchQuery = ''.obs;
  var selectedMaintenanceTypes = <MaintenanceType>[].obs;
  var maintenanceTypes = <MaintenanceType>[].obs;

  var filteredMaintenanceTypes = <MaintenanceType>[].obs;
  
  @override
  void onInit() {
    // TODO: implement onInit
    loadMaintenanceTypes();
    super.onInit();
  }

  void loadMaintenanceTypes() async {
    maintenanceTypes.value = await MaintenanceType().get();
    print(maintenanceTypes.toList());
    maintenanceTypes.refresh();
    filteredMaintenanceTypes.value = List<MaintenanceType>.from(maintenanceTypes);
    filteredMaintenanceTypes.refresh();
  }

  void search(String val) {
    searchQuery.value = val;
    
    filteredMaintenanceTypes.value = searchQuery.value.isEmpty
      ? List<MaintenanceType>.from(maintenanceTypes)
      : maintenanceTypes
          .where((maintenanceType) =>
              maintenanceType.name!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              maintenanceType.service!.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
  }
}

class MaintenanceTypesDialog extends StatelessWidget{

  const MaintenanceTypesDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(MaintenanceTypesDialogController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Maintenance Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search Maintenance Type:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: "Search maintenance type",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Obx(() { 
            return controller.filteredMaintenanceTypes.length >= 1 
            ? Expanded(
              child: ListView(
                children: controller.filteredMaintenanceTypes
                    .map((user) {
                      bool isSelected = controller.selectedMaintenanceTypes.contains(user);
                      return ListTile(
                          title: Text('${user.name}'),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () => isSelected ? controller.selectedMaintenanceTypes.remove(user) : controller.selectedMaintenanceTypes.add(user),
                        );
                    })
                    .toList(),
              ),
            )
            : SizedBox();
            }),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedMaintenanceTypes.isNotEmpty) {
                    Get.back(result: controller.selectedMaintenanceTypes.value);
                  }
                },
                child: Text("Confirm Selection"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AssetsDialogController extends GetxController {
  var searchQuery = ''.obs;
  var selectedAsset = <Asset>[].obs;
  var assets = <Asset>[].obs;

  var filteredAssets = <Asset>[].obs;
  
  @override
  void onInit() {
    // TODO: implement onInit
    loadMaintenanceTypes();
    super.onInit();
  }

  void loadMaintenanceTypes() async {
    assets.value = await Asset(maintenances: []).get();
    print(assets.toList());
    assets.refresh();
    filteredAssets.value = List<Asset>.from(assets);
    filteredAssets.refresh();
  }

  void search(String val) {
    searchQuery.value = val;
    
    filteredAssets.value = searchQuery.value.isEmpty
      ? List<Asset>.from(assets)
      : assets
          .where((asset) =>
              asset.name!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              asset.type.label.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
  }
}

class AssetTypesDialog extends StatelessWidget{

  const AssetTypesDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AssetsDialogController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Assets'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search About Asset:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: "Search on assets",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Obx(() { 
            return controller.filteredAssets.length >= 1 
            ? Expanded(
              child: ListView(
                children: controller.filteredAssets
                    .map((user) {
                      bool isSelected = controller.selectedAsset.contains(user);
                      return ListTile(
                          title: Text('${user.name}'),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () => isSelected ? controller.selectedAsset.remove(user) : controller.selectedAsset.add(user),
                        );
                    })
                    .toList(),
              ),
            )
            : SizedBox();
            }),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedAsset.isNotEmpty) {
                    Get.back(result: controller.selectedAsset.value);
                  }
                },
                child: Text("Confirm Selection"),
              ),
            )
          ],
        ),
      ),
    );
  }
}


