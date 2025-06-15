import 'package:tbc_application/app/model.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:uuid/uuid.dart';

class Visit extends Model<Visit> {

  // Attributes : 
  String id = const Uuid().v4();
  String? ministerialID;
  String? groupName;
  String? name;
  String? addressID;

  // Accessories : 

  // Constructor
  Visit({
    this.ministerialID,
    this.groupName,
    this.name,
    this.addressID,
  }) : super(collectionName: "schools");

  // Override
  @override
  Visit fromFirestore(Map<String, dynamic> data) {
    return Visit(
      ministerialID: data['ministerialID'] ?? '',
      groupName: data['groupName'] ?? '',
      name: data['name'] ?? '',
      addressID: data['address'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ministerialID": ministerialID,
      "groupName": groupName,
      "name": name,
      "address": addressID,
    };
  }

  // relationships:

    Future<Address?> address() async => addressID != null ? await Address().find(addressID!) : null;
  
  // Static helpers

  static final Visit _instance = Visit();

  static Future<Visit?> find(String id) => _instance.byID(id);
  
  static Future<List<Visit>> all() => _instance.fetchAll();

  static Future<List<Visit>> where(String field, dynamic isEqualTo) =>
      _instance.whereField(field, isEqualTo);

  static Future<Visit?> create(Map<String, dynamic> data) =>
      _instance.createRow(data);

  static Future<Visit?> insert(Map<String, dynamic> data) =>
      _instance.insertRow(data);
}
