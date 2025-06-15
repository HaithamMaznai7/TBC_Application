

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';
import 'package:tbc_application/company_data.dart';

abstract class FbAuth<T extends FbAuth<T>>{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late CollectionReference<Map<String, dynamic>> collection;

  FbAuth(String collectionName) {
    this.collection = firestore.collection(collectionName);
  }
  
  CollectionReference<Map<String, dynamic>> get userCollection =>
      firestore.collection('employee');

Future<List<T>> get() async {
  try {
    List<T> items = [];
    final snapshot = await collection.get();

    for (var doc in snapshot.docs) {
      try {
        // Fetch the associated employee if needed
        Employee? employee;
        final value = await userCollection.doc(doc.id).get();
        if (value.data() != null) {
          employee = Employee.fromMap('', value.data()!);
        }
        // Create the item using the fetched data
        T item = fromCollection(doc.id, doc.data(), employee);
        items.add(item);
      } catch (e) {
        // Log specific errors related to each document
        print('Error processing document ${doc.id}: $e');
        CustomToast.errorToast("Document Error", "Failed to process document: ${doc.id}");
      }
    }

    return items;
  } catch (e) {
    // General error handling
    CustomToast.errorToast("Find Error", e.toString());
    return [];
  }
}


  Future<void> delete() async {
    try {
      await collection.doc(id).delete();
      await userCollection.doc(id).delete();
      CustomToast.successToast("Delete Success", "Data deleted successfully");
    } catch (e) {
      CustomToast.errorToast("Delete Error", e.toString());
    }
  }

  Future<void> save() async {
    try {
      String? uid = id;
      if(uid == null && employee.email!= null) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(email: employee.email!, password: CompanyData.defaultPassword);
        uid = credential.user!.uid;
      }

      userCollection.doc(uid).set(employee.toMap());
      collection.doc(uid).set(toMap());
      T? t = await find(uid!);
      if(t != null){
        CustomToast.successToast("Enter Success", "Data entered successfully");
      }
    } catch (e) {
      CustomToast.errorToast("Created Error", e.toString());
    }
  }

  Future<T?> find(String uid) async {
    try {
      final doc = await collection.doc(uid).get();
      Employee? employee = userCollection.doc(uid).get().then((value) {
        return value.data() != null ? Employee.fromMap('', value.data()!) : null;
      }) as Employee?;
      T? item = doc.data() != null ? fromCollection(doc.id, doc.data()!, employee) : null;
      return item;
    } catch (e) {
      CustomToast.errorToast("Find Error", e.toString());
      return null;
    }
  }

  abstract Employee employee;
  abstract String? id;

  T fromCollection(String id, Map<String,dynamic> map, Employee? employee);

  Map<String, dynamic> toMap();
  
}
