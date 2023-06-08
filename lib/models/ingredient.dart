import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String id;
  String title;
  String type;
  String unit;
  bool isChecked = false;

  Ingredient({
    required this.id,
    required this.title,
    required this.type,
    required this.unit,
  });

  void toggleChecked() {
    isChecked = !isChecked;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'unit': unit,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      unit: map['unit'] ?? '',
    );
  }

  factory Ingredient.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print('data is: ${data.toString()}');

    return Ingredient(
      id: snapshot.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      unit: data['unit'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Ingredient(id: $id, title: $title, type: $type, unit: $unit)';
  }
}
