import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class FirebaseConfigure<T>{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final FirebaseAuth auth = FirebaseAuth.instance;

  String collectionName;

  FirebaseConfigure(this.collectionName);

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection(collectionName);


  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetch() async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs;
    } catch (e) {
      CustomToast.errorToast("Find Error", e.toString());
      return [];
    }

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get snapshot => collection.snapshots();

  Future<Map<String, dynamic>?> byID(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      CustomToast.errorToast("Find Error", e.toString());
      throw 'Find Error: ${e.toString()}';
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> insertRow(Map<String, dynamic> data) async {

    try {
      return await collection.add(data);
    } catch (e) {
      CustomToast.errorToast("Create Error", e.toString());
      throw 'Create Error: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> modify(String id,Map<String, dynamic> map) async {
    try {
      await collection.doc(id).update(map);
      final item = await byID(id);
      if(item != null) {
        return map;
      }else{
        return map;
      }
    } catch (e) {
      CustomToast.errorToast("Update Error", e.toString());
      throw 'Update Error: ${e.toString()}';
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> whereField(String field, dynamic isEqualTo) async {
    try {
      final snapshot = await collection.where(field, isEqualTo: isEqualTo).get();
      return snapshot.docs;
    } catch (e) {
      CustomToast.errorToast("Where Error", e.toString());
      return [];
    }
  }

  Future<void> deleteDoc(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      CustomToast.errorToast("Delete Error", e.toString());
      throw 'Delete Error: ${e.toString()}';
    }
  }
}

abstract class FirebaseModel<T extends FirebaseModel<T>> extends FirebaseConfigure<T>{

  FirebaseModel(super.collection);

  String? id;
  
  T fromCollection(String? id, Map<String, dynamic> map);

  Map<String,dynamic> toMap();

  Future<List<T>> get() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = await fetch();  
    return data.map(
      (item) => fromCollection(item.id, item.data())
    ).toList();
  }

  Future<List<T>> where(String field, dynamic isEqualTo) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = await whereField(field, isEqualTo);  
    return data.map(
      (item) => fromCollection(item.id, item.data())
    ).toList();
  }

  Future<T?> find(String i) async {
    Map<String, dynamic>? data = await byID(i);  
    if(data != null){
      return fromCollection(i,data);
    }
    return null;
  }

  Future<void> delete() async {
    if(id != null){
      await deleteDoc(id!);  
    }
  }

  Future<T> save() async {
    print(id);
    if(id != null){
      final map = await modify(id!, toMap());  
      T item = fromCollection(id!,map!);
      return item;    
    }else{
      final map = await insertRow(toMap());  
      T item = fromCollection(null,toMap());
      item.id = map.id;
      return item;      
    }
  }
}

class ExampleMode extends FirebaseModel<ExampleMode>{
  
  @override
  String? id;

  String name;
  String word;

  ExampleMode({
    this.id,
    this.name = '',
    this.word = ''
  }): super('ExampleMode');

  @override
  ExampleMode fromCollection(String? id, Map<String, dynamic> map) {
    return ExampleMode(
      id: id,
      name: map['name'] as String,
      word: map['word'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'word': word,
    };
  }

}

class ExampleMode2 extends FirebaseModel<ExampleMode2>{
  
  @override
  String? id;

  String name;
  String word;

  ExampleMode2({
    this.id,
    this.name = '',
    this.word = ''
  }): super('ExampleMode');

  @override
  ExampleMode2 fromCollection(String? id, Map<String, dynamic> map) {
    return ExampleMode2(
      id: id,
      name: map['name'] as String,
      word: map['word'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'word': word,
    };
  }
  
  HasMany address() {
    return HasMany<ExampleMode>(ExampleMode() , 'school_id', id);
  }
}

class HasMany<T extends FirebaseModel<T>>{

  final String? id;
  final String foreignKey;
  final T model;

  HasMany(this.model, this.foreignKey, this.id);

  Future<List<T>> get() async {
    if(id == null) return [];
    return await model.where(foreignKey, id);
  }

  Future<T> add(Map<String, dynamic> map) async {
    if(id != null) {
      map[foreignKey] = id;
      T newModel = model.fromCollection(id, map);
      return await newModel.save();
    }
    else {
      throw 'ID is null';
    }
  }
}

class BelongsTo<T extends FirebaseModel<T>>{

  final String id;
  final String foreignKey;

  BelongsTo(this.foreignKey, this.id);

  // Future<T?> get() async {
  //   return await T.find(id);
  // }
}