import 'package:get/get.dart';
import 'package:tbc_application/app/modules/assets/views/add_assets_view.dart';
import 'package:tbc_application/app/modules/contractors/bindings/contractors_binding.dart';
import 'package:tbc_application/app/modules/contractors/views/add_contractor_view.dart';
import 'package:tbc_application/app/modules/contractors/views/contractors_view.dart';
import 'package:tbc_application/app/modules/map/views/cities_school_view.dart';
import 'package:tbc_application/app/modules/map/views/map_view.dart';
import 'package:tbc_application/app/modules/map/bindings/map_binding.dart';
import 'package:tbc_application/app/modules/notifications/bindings/notification_binding.dart';
import 'package:tbc_application/app/modules/notifications/views/notification_view.dart';
import 'package:tbc_application/app/modules/schedule/bindings/schedule_binding.dart';
import 'package:tbc_application/app/modules/schedule/views/schedule_view.dart';
import 'package:tbc_application/app/modules/school/bindings/school_binding.dart';
import 'package:tbc_application/app/modules/school/views/school_view.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/modules/schools/views/sub_views/address_view.dart';
import 'package:tbc_application/app/modules/assets/bindings/assets_binding.dart';
import 'package:tbc_application/app/modules/assets/views/assets_view.dart';
import 'package:tbc_application/app/modules/authentication/bindings/change_password_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/change_password_view.dart';
import 'package:tbc_application/app/modules/authentication/bindings/forgot_password_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/forgot_password_view.dart';
import 'package:tbc_application/app/modules/home/bindings/home_binding.dart';
import 'package:tbc_application/app/modules/home/views/home_view.dart';
import 'package:tbc_application/app/modules/authentication/bindings/login_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/login_view.dart';
import 'package:tbc_application/app/modules/maintenence_types/bindings/maintenance_type_binding.dart';
import 'package:tbc_application/app/modules/maintenence_types/views/add_maintenence_types_view.dart';
import 'package:tbc_application/app/modules/maintenence_types/views/maintenence_types_view.dart';
import 'package:tbc_application/app/modules/more/bindings/more_binding.dart';
import 'package:tbc_application/app/modules/more/views/more_view.dart';
import 'package:tbc_application/app/modules/authentication/bindings/new_password_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/new_password_view.dart';
import 'package:tbc_application/app/modules/authentication/bindings/profile_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/profile_view.dart';
import 'package:tbc_application/app/modules/schools/bindings/schools_binding.dart';
import 'package:tbc_application/app/modules/schools/views/add_schools_view.dart';
import 'package:tbc_application/app/modules/schools/views/schools_view.dart';
import 'package:tbc_application/app/modules/supervisors/bindings/supervisors_binding.dart';
import 'package:tbc_application/app/modules/supervisors/views/add_supervisor_view.dart';
import 'package:tbc_application/app/modules/supervisors/views/supervisors_view.dart';
import 'package:tbc_application/app/modules/update_pofile/bindings/update_pofile_binding.dart';
import 'package:tbc_application/app/modules/update_pofile/views/update_pofile_view.dart';
import 'package:tbc_application/app/modules/users/bindings/users_binding.dart';
import 'package:tbc_application/app/modules/users/views/add_user_view.dart';
import 'package:tbc_application/app/modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.SCHEDULE,
      page: () => ScheduleView(),
      binding: ScheduleBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CITY_SCHOOLS,
      page: () => CitiesSchoolView(),
      binding: CitiesSchoolBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => MapView(),
      binding: MapBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.School_Info,
      page: () => SchoolDetailsView(),
      binding: SchoolDetailsBinding(),
      transition: Transition.fadeIn,
      arguments: School
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => MoreView(),
      binding: MoreBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Authentication
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_POFILE,
      page: () => UpdatePofileView(),
      binding: UpdatePofileBinding(),
    ),
    // Authentication
    // GetPage(
    //   name: _Paths.DETAIL_PRESENCE,
    //   page: () => DetailPresenceView(),
    //   binding: DetailPresenceBinding(),
    // ),

    GetPage(
      name: _Paths.MAINTENANCE_TYPES_FEATURE,
      page: () => MaintenanceTypesView(),
      binding: MaintenanceTypeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MAINTENANCE_TYPES_FEATURE,
      page: () => AddEditMaintenanceTypeView(),
      binding: MaintenanceTypeBinding(),
    ),
    GetPage(
      name: _Paths.SCHOOL_FEATURE,
      page: () => SchoolsListView(),
      binding: SchoolsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SCHOOL,
      page: () => AddEditSchoolView(),
      binding: SchoolsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_ADDRESS,
      page: () => AddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_ASSETS,
      page: () => AssetsView(),
      binding: AssetsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ASSET,
      page: () => AddEditAssetView(),
      binding: AssetsBinding(),
    ),
  
    // MORE ROUTES HERE

    // GetPage(
    //   name: _Paths.VIEW_EMPLOYEES,
    //   page: () => UsersView(),
    //   binding: AddEmployeeBinding(),
    // ),
    // GetPage(
    //   name: _Paths.ADD_EMPLOYEE,
    //   page: () => AddUserView(),
    //   binding: AddEmployeeBinding(),
    // ),

    GetPage(
      name: _Paths.VIEW_SUPERVISOR,
      page: () => SupervisorsView(),
      binding: SupervisorsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SUPERVISOR,
      page: () => AddSupervisorView(),
      binding: SupervisorsBinding(),
    ),

    GetPage(
      name: _Paths.VIEW_USERS,
      page: () => UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.ADD_USER,
      page: () => AddUserView(),
      binding: UsersBinding(),
    ),

    GetPage(
      name: _Paths.VIEW_CONTRACTOR,
      page: () => ContractorsView(),
      binding: ContractorsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CONTRACTOR,
      page: () => AddContractorView(),
      binding: ContractorsBinding(),
    ),

  ];
}
