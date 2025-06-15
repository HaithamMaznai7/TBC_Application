import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tbc_application/app/model_example.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';

class School extends FirebaseModel<School> {

  // static List<String> excelFileHeaders = ['ID', 'Name', 'Ministerial ID', 'Group Schools Name', 'Level', 'Type'];
  static List<String> excelFileHeaders = ['ID', 'Name', 'Ministerial ID', 'Group Schools Name', 'Level', 'Type', 'Region', 'Ministerial Office'];
  // static List<String> excelFileHeaders = ['ID', 'Building Owner', 'Building Size', 'Shift', 'Building Type', 'Updates Notes', 'Ministerial Shared No', 'Shared Name'];

  @override
  String? id;
  // Attributes : 
  String? ministerialID;
  String? name;
  String? group;
  SchoolLevel level;
  SchoolType type;
  DocumentReference? addressID;
  // State
  // Office
  // City
  // Address
  String? supervisor;
  String? buildingOwner;
  String? buildingSize;
  String? schoolSize;
  String? shift;
  String? schoolType;
  String? notes;
  String? ministerialGroupNumber;
  String? groupName;
  String? buildingType;
  String? leaderName;
  String? leaderMobile;
  String? leaderEmail;
  String? securityGuardName;
  String? securityGuardMobile;
  // List<Supervisor> supervisors = [];
  // List<Supervisor> contractors = [];
  
  // Accessories : 
  
  // Constructor
  School({
    this.id,
    this.ministerialID,
    this.group,
    this.name,
    this.level = SchoolLevel.kindergarten,
    this.type = SchoolType.male,
    this.addressID,
  }) : super("schools");

  static School empty() {
    return School();
  }
  // Override
  @override
  School fromCollection(String? id, Map<String, dynamic> data) {
    DocumentReference<Map<String,dynamic>>? addressDoc = null;
    if(data['address'] != null){
      addressDoc = data['address'] as DocumentReference<Map<String,dynamic>>;
    }
    return School(
      id: id,
      ministerialID: data['ministerialID'] ?? '',
      group: data['groupName'] ?? '',
      name: data['name'] ?? '',
      level: SchoolLevel.set(data['level'].toString()) ,
      type: SchoolType.set(data['type'].toString()) ,
      // addressID: addressDoc?.id ?? '',
      // contractors: data.containsKey('contractors') && data['contractors'] != null
      //     ? List<Supervisor>.from(data['contractors'].map((item) => Supervisor.set(item)))
      //     : [],

      // supervisors: data.containsKey('supervisors') && data['supervisors'] != null
      //     ? List<Supervisor>.from(data['supervisors'].map((item) => Supervisor.set(item)))
      //     : [],
    );
  }

  static School fromCsvRow(Map<String, dynamic> data) {
    return School(
      id: data['ID'].toString(),
      ministerialID: data['ministerialID'],
      group: data['groupName'] ?? '',
      name: data['name'] ?? '',
      level: SchoolLevel.set(data['level'].toString()) ,
      type: SchoolType.set(data['type'].toString()) ,
      // addressID: addressDoc?.id ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ministerialID": ministerialID,
      "groupName": group,
      "name": name,
      "level": level.value,
      "type": type.value,
      "address": addressID,
      // "contractors" : contractors.map((item) => item.toMap()).toList(),
      // "supervisors" : supervisors.map((item) => item.toMap()).toList(),
    };
  }

  List<String> toCsvRow() {
    return [
      id.toString(),
      name.toString(),
      ministerialID.toString(),
      group.toString(),
      level.label,
      type.label,
    ];
  }

  factory School.fromMap(String?id, Map<String, dynamic> data) {
    return School(
      id: id,
      name: data['name'].toString(),
      ministerialID: data['ministerialID'].toString(),
      group: data['groupName'].toString(),
      level: SchoolLevel.set(data['level']),
      type: SchoolType.set(data['type']),
      addressID: data['address'] as DocumentReference?
    );
  }

  Future<Address?> address() async {
    final doc = await addressID?.get();
    return doc != null ? Address.fromMap(doc.id, doc.data() as Map<String,dynamic>) : null;
  }
}

enum SchoolType {
   male, female; 
   
  String get label => this.toString().split('.').last;

  String get value => this.toString().split('.').last;

  static SchoolType set(String? value) {
    switch (value) {
      case 'female':
        return SchoolType.female;
      case 'male':
        return SchoolType.male;
      case 'بنات':
        return SchoolType.female;
      case 'بنين':
        return SchoolType.male;
      default:
        return SchoolType.male;
    }
  }
}
enum SchoolLevel {
  
   kindergarten, primary, middle, secondary, groupOfAllLevels;
  String get label => this.toString().split('.').last;

  String get value => this.toString().split('.').last;

    static SchoolLevel set(String? value) {
    switch (value) {
      case 'kindergarten':
        return SchoolLevel.kindergarten;
      case 'primary':
        return SchoolLevel.primary;
      case 'middle':
        return SchoolLevel.middle;
      case 'secondary':
        return SchoolLevel.secondary;
      case 'مرحلة رياض الاطفال':
        return SchoolLevel.kindergarten;
      case 'المرحلة الابتدائية':
        return SchoolLevel.primary;
      case 'المرحلة المتوسطة':
        return SchoolLevel.middle;
      case 'المرحلة الثانوية':
        return SchoolLevel.secondary;
      default:
        return SchoolLevel.groupOfAllLevels;
    }
   }
}
/* import 'address.dart';
import 'school_details.dart';
import 'supervisor.dart';

class School {
  final int id;
  final String name;
  final Address? address;
  final SchoolDetails? details;
  final List<Supervisor> supervisors;

  School({
    required this.id,
    required this.name,
    this.address,
    this.details,
    this.supervisors = const [],
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      details: json['details'] != null ? SchoolDetails.fromJson(json['details']) : null,
      supervisors: json['supervisors'] != null
          ? (json['supervisors'] as List).map((e) => Supervisor.fromJson(e)).toList()
          : [],
    );
  }
}
 */