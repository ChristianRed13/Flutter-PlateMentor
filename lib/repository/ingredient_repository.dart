import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient.dart';

class IngredientRepository {
  final CollectionReference _ingredientCollection =
      FirebaseFirestore.instance.collection('ingredients');

  Future<List<Ingredient>> getIngredients() async {
    try {
      final snapshot = await _ingredientCollection.get();
      final ingredients =
          snapshot.docs.map((doc) => Ingredient.fromSnapshot(doc)).toList();
      //print(ingredients);
      return ingredients;
    } catch (e) {
      throw Exception('Error occurred while fetching ingredients: $e');
    }
  }

  Future<List<Ingredient>> getIngredientsRecipe(
      List<String> ingredientsId) async {
    try {
      final snapshot = await _ingredientCollection.get();
      final ingredients = snapshot.docs
          .map((doc) => Ingredient.fromSnapshot(doc))
          .where((element) => ingredientsId.contains(element.id))
          .toList();

      //print(ingredients);
      return ingredients;
    } catch (e) {
      throw Exception('Error occurred while fetching ingredients: $e');
    }
  }
}
