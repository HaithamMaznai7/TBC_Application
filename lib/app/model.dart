import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';
import 'package:tbc_application/company_data.dart';

abstract class Model<T extends Model<T>> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String collectionName;
  abstract String id;

  Model({required this.collectionName});

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection(collectionName);

  T fromFirestore(Map<String, dynamic> data);

  Map<String, dynamic> toMap();

  Future<T?> save() async {
    T? obj = await byID(id);
    if(obj != null) {
      await update();
    }
    await createRow(toMap());

    return await byID(id);
  }

  Future<T?> byID(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (doc.exists) {
        final data = doc.data();
        T? obj = data != null ? fromFirestore(data) : null;
        if(obj == null) {
          CustomToast.errorToast("Find Error", "Object is null");
          return null;
        }
        obj.id = doc.id;
        return obj;
      }
    } catch (e) {
      CustomToast.errorToast("Find Error", e.toString());
    }
    return null;
  }

  Future<List<T>> whereField(String field, dynamic isEqualTo) async {
    try {
      final snapshot =
      await collection.where(field, isEqualTo: isEqualTo).get();
      return snapshot.docs.map((doc) {
        T obj = fromFirestore(doc.data());
        obj.id = doc.id;
        return obj;
      }).toList();
    } catch (e) {
      CustomToast.errorToast("Where Error", e.toString());
      return [];
    }
  }

  Future<List<T>> fetchAll() async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs.map((doc) {
        T obj = fromFirestore(doc.data());
        obj.id = doc.id;
        return obj;
      }).toList();
    } catch (e) {
      CustomToast.errorToast("Fetch Error", e.toString());
      return [];
    }
  }

  Future<T> insertRow(Map<String, dynamic> data) async {

    try {
      final ref = collection.doc(id);
      await ref.set(data);
      return fromFirestore(data);
    } catch (e) {
      CustomToast.errorToast("Insert Error", e.toString());
      throw 'Insert Error: $e';
    }
  }

  Future<T?> createRow(Map<String, dynamic> data) async {
    try {
      if(T is Employee){
          
          String defaultPassword = CompanyData.defaultPassword;
          // if the password is match, then continue the create user process
          UserCredential employeeCredential = await auth.createUserWithEmailAndPassword(
            email: data['email'],
            password: defaultPassword,
          );
          T? user = null;
          if (employeeCredential.user != null) {
            String uid = employeeCredential.user!.uid;
            await collection.doc(uid).set(data);
            return await byID(uid);
          }

          await employeeCredential.user!.sendEmailVerification();
      }else{
        final obj = await collection.add(data);
        id = obj.id;
        return await byID(obj.id);
      }

    } catch (e) {
      CustomToast.errorToast("Create Error", e.toString());
      throw 'Create Error: $e';
    }
  }

  Future<bool> update({Map<String, dynamic>? map}) async {
    final data = map ?? toMap();
    try {
      await collection.doc(id).update(data);
      return true;
    } catch (e) {
      CustomToast.errorToast("Update Error", e.toString());
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await collection.doc(id).delete();
      return true;
    } catch (e) {
      CustomToast.errorToast("Delete Error", e.toString());
      return false;
    }
  }
}
