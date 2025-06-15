
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tbc_application/app/model_example.dart';
import 'package:tbc_application/app/modules/maintenence_types/models/maintenance_type_model.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';

class Asset extends FirebaseModel<Asset>{

  @override
  String? id;
  
  String? name;
  WorkScop type;
  List<DocumentReference<Map<String, dynamic>>> maintenances;

  Asset({
    this.id,
    this.name,
    this.type = WorkScop.none,
    required this.maintenances,
  }) : super('assets');

  @override
  Asset fromCollection(String? id, Map<String, dynamic> map) {
    // TODO: implement fromCollection
    return Asset(
      id: id, 
      name: map['name'],
      type: WorkScop.set(map['type']),
      maintenances: (map['maintenances'] as List<dynamic>).map((e) => e as DocumentReference<Map<String, dynamic>>).toList(),
    );
  }

Future<List<MaintenanceType>> getMaintenances() async {
  List<MaintenanceType> items = [];

  try {
    // Use Future.wait to collect async results
    items = await Future.wait(
      maintenances.map((DocumentReference<Map<String, dynamic>> item) async {
        try {
          print('Fetching: ${item.path}');
          DocumentSnapshot<Map<String, dynamic>> doc = await item.get();

          if (doc.exists && doc.data() != null) {
            MaintenanceType m = MaintenanceType().fromCollection(doc.id, doc.data()!);
            m.id = doc.id;
            print('Maintenance Loaded: ${m.name}');
            return m;
          } else {
            print('Maintenance not found for: ${item.id}');
            return MaintenanceType(id: item.id, name: 'Unknown');
          }
        } catch (e) {
          print('Error fetching maintenance: $e');
          return MaintenanceType(id: item.id, name: 'Error');
        }
      }).toList(),
    );

    print('Total Maintenances Loaded: ${items.length}');
    return items;
  } catch (e) {
    print('Error loading maintenances: $e');
    return [];
  }
}


  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.label,
      'maintenances': maintenances,
    };
  }

}