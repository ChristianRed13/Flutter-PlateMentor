import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  List<String> dietPlan;
  List<String> favorites;
  Map<String, int> groceries;

  User({
    required this.id,
    required this.email,
    required this.dietPlan,
    required this.favorites,
    required this.groceries,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, dietPlan: $dietPlan, favorites: $favorites, groceries: $groceries)';
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print('data is: ${data.toString()}');

    return User(
      id: snapshot.id,
      email: data['email'] ?? '',
      dietPlan: List<String>.from(data['dietPlan']),
      favorites: List<String>.from(data['favorites']),
      groceries: Map<String, int>.from(data['groceries']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'dietplan': dietPlan,
      'favorites': favorites,
      'groceries': groceries,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      dietPlan: List<String>.from(map['dietPlan']),
      favorites: List<String>.from(map['favorites']),
      groceries: Map<String, int>.from(map['groceries']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
