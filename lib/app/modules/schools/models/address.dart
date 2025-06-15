import 'package:tbc_application/app/model.dart';
import 'package:tbc_application/app/model_example.dart';
import 'package:uuid/uuid.dart';

class Address  extends FirebaseModel<Address> {
  
  static List<String> excelFileHeaders = ['ID', 'Region', 'City', 'Street', 'Level', 'Type', 'Region', 'Ministerial Office'];
  
  @override
  String? id;
  String? region;
  String? cityID;
  String? street;
  String? addressLine1;
  String? addressLine2;
  String? location;
  double? latitude;
  double? longitude;

  // Accessories : 
  
  // Constructor
  Address({
    this.id,
    this.region,
    this.cityID,
    this.street,
    this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
  }) : super("addresses");

  // Override
  @override
  Address fromCollection(String? id, Map<String, dynamic> data) {
    return Address(
      id: id,
      region: data['region'],
      cityID: data['cityID'],
      street: data['street'],
      addressLine1: data['addressLine1'],
      addressLine2: data['addressLine2'],
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
    );
  }

  static Address fromMap(String? id, Map<String, dynamic> data) {
    return Address(
      id: id,
      region: data['region'],
      cityID: data['cityID'],
      street: data['street'],
      addressLine1: data['addressLine1'],
      addressLine2: data['addressLine2'],
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'cityID': cityID,
      'street': street,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'latitude': latitude,
      'longitude': longitude,
    };
  }



  // relationships:
  
}
