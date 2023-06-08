import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plate_mentor/repository/category_repository.dart';

import '../../models/category.dart';
import 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<CategoriesByIds>(_onGetCategoryById);
    on<FetchCategory>(_onGetCategories);
  }

  void _onGetCategoryById(
      CategoriesByIds event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    try {
      //print(event.ids);
      final List<Category> categories =
          await categoryRepository.getCategoriesByIds(event.ids);
      //print('categories bloc: $categories');
      emit(CategoriesLoadedIds(categories: categories));
      //emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: 'Failed to fetch categories.'));
    }
  }

  void _onGetCategories(
      FetchCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final List<Category> categories =
          await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: 'Failed to get categories.'));
    }
  }
}
