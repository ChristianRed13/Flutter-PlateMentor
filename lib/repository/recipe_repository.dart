import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';

class RecipeRepository {
  final CollectionReference _recipeCollection =
      FirebaseFirestore.instance.collection('recipe');

  Future<List<Recipe>> getRecipes() async {
    try {
      final snapshot = await _recipeCollection.get();
      final recipes =
          snapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();

      return recipes;
    } catch (e) {
      print('Error occurred while fetching recipes: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Recipe>> getRecipesById(List<String> recipesIds) async {
    try {
      final snapshot = await _recipeCollection.get();
      final recipes = snapshot.docs
          .map((doc) => Recipe.fromSnapshot(doc))
          .where((element) => recipesIds.contains(element.id))
          .toList();

      return recipes;
    } catch (e) {
      print('Error occurred while fetching recipes: $e');
      throw Exception(e.toString());
    }
  }
}
