import '../../models/ingredient.dart';

abstract class IngredientState {}

class IngredientInitialState extends IngredientState {}

class IngredientLoadingState extends IngredientState {}

class IngredientLoadedState extends IngredientState {
  final List<Ingredient> ingredients;

  IngredientLoadedState(this.ingredients);
}

class IngredientRecipeLoadedState extends IngredientState {
  final List<Ingredient> ingredients;

  IngredientRecipeLoadedState(this.ingredients);
}

class IngredientErrorState extends IngredientState {
  final String errorMessage;

  IngredientErrorState(this.errorMessage);
}
