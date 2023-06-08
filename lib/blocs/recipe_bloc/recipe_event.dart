// Events
import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipes extends RecipeEvent {}

class FetchRecipesById extends RecipeEvent {
  List<String> ids;
  FetchRecipesById({
    required this.ids,
  });

  @override
  List<Object> get props => [ids];
}
