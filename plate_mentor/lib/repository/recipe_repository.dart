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

  Future<List<Recipe>> getNewRecipes() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month);
      final endOfMonth =
          DateTime(now.year, now.month + 1).subtract(Duration(days: 1));

      final snapshot = await _recipeCollection
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      final recipes =
          snapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();

      return recipes;
    } catch (e) {
      print('Error occurred while fetching recipes: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Recipe>> getRecipesWithLowestTimes() async {
    try {
      final snapshot = await _recipeCollection.get();

      final recipes =
          snapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();

      if (recipes.length >= 5) {
        return recipes.take(5).toList();
      } else {
        final sortedRecipes = List<Recipe>.from(recipes)
          ..sort((a, b) =>
              (a.cooktime + a.preptime).compareTo(b.cooktime + b.preptime));

        return sortedRecipes;
      }
    } catch (e) {
      print('Error occurred while fetching recipes: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getRecipesByCategoriesAndCalories(
      List<String> categoriesLikes,
      List<String> categoriesDisliked,
      int maxCalories) async {
    try {
      final snapshot = await _recipeCollection.get();

      final recipes = snapshot.docs
          .map((doc) => Recipe.fromSnapshot(doc))
          .where((recipe) => !categoriesDisliked
              .any((category) => (recipe.categories).contains(category)))
          .where((recipe) => categoriesLikes
              .any((category) => (recipe.categories).contains(category)))
          .where((element) => element.calories <= maxCalories + 50)
          .toList();

      return recipes.map((recipe) => recipe.id).toList();
    } catch (e) {
      print('Error occurred while fetching recipes: $e');
      throw Exception(e.toString());
    }
  }
}
