import '../bloc_exports.dart';

abstract class IngredientEvent extends Equatable {
  const IngredientEvent();

  @override
  List<Object> get props => [];
}

class LoadIngredientsEvent extends IngredientEvent {}

class LoadIngredientsRecipeEvent extends IngredientEvent {
  List<String> ingredientsId;

  LoadIngredientsRecipeEvent({
    required this.ingredientsId,
  });

  @override
  List<Object> get props => [ingredientsId];
}
