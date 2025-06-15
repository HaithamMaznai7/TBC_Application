import 'package:tbc_application/app/model_example.dart';
import 'package:uuid/uuid.dart';

class MaintenanceType  extends FirebaseModel<MaintenanceType> {
    
  static List<String> excelFileHeaders = ['ID', 'Name', 'Service', 'Unit', 'Frequency'];

  @override
  String? id;
  
  String? name;
  String? service;
  String? unit;
  int? frequency;

  // Accessories : 
  
  // Constructor
  MaintenanceType({
    this.id,
    this.name,
    this.service,
    this.unit,
    this.frequency,
  }) : super("maintenance_types");

  // Override
  @override
  MaintenanceType fromCollection(String? id, Map<String, dynamic> data) {
    return MaintenanceType(
      id: id,
      name: data['name'],
      service: data['service'],
      unit: data['unit'],
      frequency: data['frequency'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'service': service,
      'unit': unit,
      'frequency': frequency,
    };
  }

  List<String> toCsvRow() {
    return [
      id.toString(),
      name.toString(),
      service.toString(),
      unit.toString(),
      frequency.toString(),
    ];
  }

  factory MaintenanceType.fromMap(Map<String, dynamic> data) {
    return MaintenanceType(
      name: data['Name'],
      service: data['Service'],
      unit: data['Unit'],
      frequency: data['Frequency'],
    );
  }

}