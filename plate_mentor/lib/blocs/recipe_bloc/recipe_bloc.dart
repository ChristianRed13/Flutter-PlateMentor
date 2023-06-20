import 'package:plate_mentor/blocs/recipe_bloc/recipe_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_state.dart';

import '../../models/recipe.dart';
import '../../repository/recipe_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<FetchRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final List<Recipe> recipes = await recipeRepository.getRecipes();
        //print(recipes);
        emit(RecipeLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: 'Failed to fetch recipes.'));
      }
    });
    on<FetchRecipesById>((event, emit) async {
      emit(RecipeLoading());
      try {
        final List<Recipe> recipes =
            await recipeRepository.getRecipesById(event.ids);
        //print(recipes);
        emit(RecipesByIdLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: 'Failed to fetch recipes.'));
      }
    });
    on<FetchNewRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final List<Recipe> recipes = await recipeRepository.getNewRecipes();
        //print(recipes);
        emit(NewRecipesLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: 'Failed to fetch recipes.'));
      }
    });
    on<FetchQuickRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final List<Recipe> recipes =
            await recipeRepository.getRecipesWithLowestTimes();
        //print(recipes);
        emit(QuickRecipesLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipeError(message: 'Failed to fetch recipes.'));
      }
    });
  }

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is FetchRecipes) {
      yield RecipeLoading();
      try {
        final List<Recipe> recipes = await recipeRepository.getRecipes();
        yield RecipeLoaded(recipes: recipes);
      } catch (e) {
        yield RecipeError(message: 'Failed to fetch recipes.');
      }
    }
  }
}
