import 'package:tbc_application/app/model.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:uuid/uuid.dart';

class City  extends Model<City> {
  
  String id = const Uuid().v4();
  String? name;
  String? region;
  String? image;
  double lat;
  double lng;

  // Accessories : 
  
  // Constructor
  City({
    this.name,
    this.region,
    this.image,
    this.lat = 24.7136,
    this.lng = 46.6753,
  }) : super(collectionName: "cities");

  // Override
  @override
  City fromFirestore(Map<String, dynamic> data) {
    return City(
      name: data['name'],
      region: data['region'],
      image: data['image'],
      lat: data['lat'],
      lng: data['lng'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
      'image': image,
      'lat': lat,
      'lng': lng,
    };
  }

  // relationships:

  Future<List<School>> schools() async => await School().where('cityID', id);

  // Static helpers

  static final City _instance = City();

  static Future<City?> find(String id) => _instance.byID(id);

  static Future<List<City>> all() => _instance.fetchAll();

  static Future<List<City>> where(String field, dynamic isEqualTo) =>
      _instance.whereField(field, isEqualTo);

  static Future<City?> create(Map<String, dynamic> data) =>
      _instance.createRow(data);

  static Future<City?> insert(Map<String, dynamic> data) =>
      _instance.insertRow(data);
}
