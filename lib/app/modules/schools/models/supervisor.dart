import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Supervisor{
  WorkScop workScop;
  String userID;

  Supervisor({
    required this.workScop,
    required this.userID,
  });

  factory Supervisor.set(data)
    => Supervisor(
      workScop: WorkScop.set(data['workScop']), 
      userID: data['userID']
    );

  Map toMap()
    => {
      'workScop': workScop.label,
      'userID': userID,
    };
}

class Principal {
  final String id;
  final String name;
  final String phone;

  Principal({required this.id, required this.name, required this.phone});

  factory Principal.fromFirebase(DocumentSnapshot<Map<String, dynamic>> doc)
  {
    final data = doc.data();
    return Principal(id: doc.id , name: data?['name'], phone: data?['phone']);
  } 
  
  Map toMap()
    => {
      'id': id,
      'name': name,
      'phone': phone,
    };
}

enum WorkScop {
  cleaning, 
  maintenance,
  airConditioning,
  none;

  factory WorkScop.set(String? value){
    switch (value) {
      case 'Cleaning':
        return WorkScop.cleaning;
      case 'Maintenance':
        return WorkScop.maintenance;
      case 'Air Conditioning':
        return WorkScop.airConditioning;
      default:
        return WorkScop.none;
    }
  }

  String get label {
    switch (this) {
      case WorkScop.cleaning:
        return 'Cleaning';
      case WorkScop.maintenance:
        return 'Maintenance';
      case WorkScop.airConditioning:
        return 'Air Conditioning';
      case WorkScop.none:
        return '';
    }
  }
}