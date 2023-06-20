import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plate_mentor/models/category.dart';

import '../models/recipe.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

//make another function that should run once at start of program

  void updateNumbers() async {
    try {
      final snapshot = await _categoriesCollection.get();
      for (final categoryDoc in snapshot.docs) {
        final categoryId = categoryDoc.id;

        // Retrieve recipes for the current category
        final QuerySnapshot recipesSnapshot = await _firestore
            .collection('recipe')
            .where('categories', arrayContains: categoryId)
            .get();

        // Get the count of recipes for the current category
        final int recipeCount = recipesSnapshot.docs.length;

        // Update the category document with the new count
        await categoryDoc.reference.update({'number': recipeCount});
      }
    } catch (e) {
      print('Error occurred while fetching category: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _categoriesCollection.get();
      final categories =
          snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();

      return categories;
    } catch (e) {
      print('Error occurred while fetching category: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Category>> getCategoriesByIds(List<String> ids) async {
    try {
      final snapshot = await _categoriesCollection.get();
      final categories = snapshot.docs
          .map((doc) => Category.fromSnapshot(doc))
          .where((element) => ids.contains(element.id))
          .toList();
      //print('categories: $categories');
      return categories;
    } catch (e) {
      print('Error occurred while fetching categories by IDs: $e');
      throw Exception(e.toString());
    }
  }
}
