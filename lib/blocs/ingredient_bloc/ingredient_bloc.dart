import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/ingredient.dart';
import '../../repository/ingredient_repository.dart';
import '../recipe_bloc/recipe_event.dart';
import 'ingredient_event.dart';
import 'ingredient_state.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final IngredientRepository ingredientRepository;

  IngredientBloc({required this.ingredientRepository})
      : super(IngredientInitialState()) {
    on<LoadIngredientsRecipeEvent>((event, emit) async {
      emit(IngredientLoadingState());
      try {
        final List<Ingredient> ingredeints = await ingredientRepository
            .getIngredientsRecipe(event.ingredientsId);

        emit(IngredientRecipeLoadedState(ingredeints));
      } catch (e) {
        emit(IngredientErrorState('Failed to fetch ingredients.'));
      }
    });
    on<LoadIngredientsEvent>((event, emit) async {
      emit(IngredientLoadingState());
      try {
        final List<Ingredient> ingredeints =
            await ingredientRepository.getIngredients();

        emit(IngredientLoadedState(ingredeints));
      } catch (e) {
        emit(IngredientErrorState('Failed to fetch ingredients.'));
      }
    });
  }

  @override
  Stream<IngredientState> mapEventToState(IngredientEvent event) async* {
    if (event is LoadIngredientsEvent) {
      yield IngredientLoadingState();
      try {
        final List<Ingredient> ingredients =
            await ingredientRepository.getIngredients();
        yield IngredientLoadedState(ingredients);
      } catch (e) {
        yield IngredientErrorState('Failed to load ingredients: $e');
      }
    }
  }
}
