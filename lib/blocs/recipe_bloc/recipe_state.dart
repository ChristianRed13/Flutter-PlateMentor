import '../../models/recipe.dart';
import '../bloc_exports.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class RecipesByIdLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipesByIdLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError({required this.message});

  @override
  List<Object> get props => [message];
}
