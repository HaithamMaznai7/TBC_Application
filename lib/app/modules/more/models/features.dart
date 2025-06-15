import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feature {

  final IconData icon;
  final String title;
  final String collection; 
  final String route;
  final RxString count = "0".obs;

  Feature({
    required this.icon,
    required this.title,
    required this.collection,
    required this.route,
  });

  Future<void> getCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      int totalCount = snapshot.size;
      count.value = _formatCount(totalCount);
    } catch (e) {
      print("Error fetching count for $collection: $e");
      count.value = "0";
    }
  }

  /// 🔹 تحويل العدد إلى صيغة مختصرة (1K, 2K, ...)
  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else {
      return "${(count / 1000).toStringAsFixed(0)}K";
    }
  }
}