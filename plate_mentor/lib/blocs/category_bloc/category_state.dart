import 'package:plate_mentor/models/category.dart';

import '../bloc_exports.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesLoadedIds extends CategoryState {
  final List<Category> categories;

  CategoriesLoadedIds({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
