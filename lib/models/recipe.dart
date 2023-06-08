import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id;
  int calories;
  int carbs;
  List<String> categories;
  int cooktime;
  DateTime date;
  int fats;
  Map<String, int> ingredients;
  String photo;
  int preptime;
  int protein;
  int servings;
  List<String> steps;
  String title;
  String? filePath;

  Recipe({
    required this.id,
    required this.calories,
    required this.carbs,
    required this.categories,
    required this.cooktime,
    required this.date,
    required this.fats,
    required this.ingredients,
    required this.photo,
    required this.preptime,
    required this.protein,
    required this.servings,
    required this.steps,
    required this.title,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      calories: map['calories'] ?? 0,
      carbs: map['carbs'] ?? 0,
      categories: List<String>.from(map['categories'] ?? []),
      cooktime: map['cooktime'] ?? 0,
      date: map['date'] != null ? map['date'].toDate() : DateTime.now(),
      fats: map['fats'] ?? 0,
      ingredients: Map<String, int>.from(map['ingredients'] ?? {}),
      photo: map['photo'] ?? '',
      preptime: map['preptime'] ?? 0,
      protein: map['protein'] ?? 0,
      servings: map['servings'] ?? 0,
      steps: List<String>.from(map['steps'] ?? []),
      title: map['title'] ?? '',
    );
  }

  factory Recipe.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print('data is: ${data.toString()}');
    print('snapshot id is: ${snapshot.id}');
    print('calories: ${data['calories']}');
    print('carbs: ${data['carbs']}');
    print('categories: ${data['categories']}');
    print('cooktime: ${data['cooktime']}');
    print('date: ${(data['date'] as Timestamp).toDate()}');
    print('fats: ${data['fats']}');
    print('ingredients: ${data['ingredients']}');
    print('photo: ${data['photo']}');
    print('preptime: ${data['preptime']}');
    print('protein: ${data['protein']}');
    print('servings: ${data['servings']}');
    print('steps: ${data['steps']}');
    print('title: ${data['title']}');
    return Recipe(
      id: snapshot.id,
      calories: data['calories'],
      carbs: data['carbs'],
      categories: List<String>.from(data['categories'] ?? []),
      cooktime: data['cooktime'],
      date: (data['date'] as Timestamp).toDate(),
      fats: data['fats'],
      ingredients: Map<String, int>.from(data['ingredients'] ?? {}),
      photo: data['photo'],
      preptime: data['preptime'],
      protein: data['protein'],
      servings: data['servings'],
      steps: List<String>.from(data['steps'] ?? []),
      title: data['title'],
    );
  }

  Recipe copyWith({String? id}) {
    return Recipe(
      id: id ?? this.id,
      calories: calories,
      carbs: carbs,
      categories: categories,
      cooktime: cooktime,
      date: date,
      fats: fats,
      ingredients: ingredients,
      photo: photo,
      preptime: preptime,
      protein: protein,
      servings: servings,
      steps: steps,
      title: title,
    );
  }

  @override
  String toString() {
    return 'Recipe(calories: $calories, carbs: $carbs, categories: $categories, cooktime: $cooktime, date: $date, fats: $fats, ingredients: $ingredients, photo: $photo, preptime: $preptime, protein: $protein, servings: $servings, steps: $steps, title: $title)';
  }
}
