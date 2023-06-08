import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  String id;
  String title;
  String imageUrl;
  Color color;
  int number;
  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'color': color.value,
      'number': number,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      color: Color(map['color']),
      number: map['number']?.toInt() ?? 0,
    );
  }

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print('data is: ${data.toString()}');

    return Category(
      id: snapshot.id,
      title: data['title'] ?? '',
      imageUrl: 'assets/${data['icon']}' ?? '',
      color: Color(
        int.parse(
          data['color'],
        ),
      ),
      number: data['number'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, title: $title, imageUrl: $imageUrl, color: $color, number: $number)';
  }
}
