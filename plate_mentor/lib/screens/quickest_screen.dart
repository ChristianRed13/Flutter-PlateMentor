import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'package:plate_mentor/blocs/category_bloc/category_bloc.dart';
import 'package:plate_mentor/blocs/category_bloc/category_event.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_event.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_state.dart';
import 'package:plate_mentor/models/category.dart';
import 'package:plate_mentor/models/recipe.dart';
import 'package:plate_mentor/repository/category_repository.dart';
import 'package:plate_mentor/repository/user_repository.dart';
import 'package:plate_mentor/widgets/food_card.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../blocs/user_bloc/user_event.dart';
import '../blocs/user_bloc/user_state.dart';
import '../models/user.dart';
import '../repository/recipe_repository.dart';
import 'recipe_screen.dart';

class QuickesRecipesScreen extends StatefulWidget {
  static const id = 'quickest_recipes_screen';

  @override
  State<QuickesRecipesScreen> createState() => _QuickesRecipesScreenState();
}

class _QuickesRecipesScreenState extends State<QuickesRecipesScreen> {
  void updateUser(User user) {
    UserRepository(getStorage: GetStorage()).updateUser(user);
    GetStorage().write('favorites', user.favorites);
  }

  List<String> favorites = [];

  @override
  void initState() {
    if (GetStorage().read('favorites') != null) {
      List<dynamic> list = GetStorage().read('favorites');
      favorites = list.map((item) => item as String)!.toList();
    }

    super.initState();
  }

  void readFavorites() {
    setState(() {
      if (GetStorage().read('favorites') != null) {
        List<dynamic> list = GetStorage().read('favorites');
        favorites = list.map((item) => item as String)!.toList();
      }
    });
  }

  void writeFavorites(List<String> myFavorites) {
    setState(() {
      GetStorage().write('favorites', myFavorites);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5 Quickest Meals'),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(recipeRepository: RecipeRepository()),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            final recipeBloc = BlocProvider.of<RecipeBloc>(context);

            if (state is RecipeInitial) {
              recipeBloc.add(FetchQuickRecipes());
            }

            if (state is RecipeLoading) {
              return CircularProgressIndicator();
            }

            if (state is QuickRecipesLoaded) {
              List<Recipe> recipes = state.recipes;

              return GridView.count(
                padding: EdgeInsets.all(5),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: List.generate(recipes.length, (index) {
                  final recipe = recipes[index];
                  final categories = recipes[index].categories;
                  return BlocProvider(
                    create: (context) =>
                        CategoryBloc(categoryRepository: CategoryRepository()),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        final categoryBlocSecond =
                            BlocProvider.of<CategoryBloc>(context);
                        if (state is CategoryInitial) {
                          categoryBlocSecond.add(
                            CategoriesByIds(ids: categories),
                          );
                        }

                        if (state is CategoryLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is CategoryLoaded) {
                          categoryBlocSecond.add(
                            CategoriesByIds(ids: categories),
                          );
                        }

                        if (state is CategoriesLoadedIds) {
                          List<Category> categoriesToShow = state.categories;

                          return FoodCard(
                            icon: favorites.contains(recipe.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            onTapFavorites: () {
                              favorites.contains(recipe.id)
                                  ? favorites.remove(recipe.id)
                                  : favorites.add(recipe.id);
                              writeFavorites(favorites);
                            },
                            name: recipe.title,
                            imageUrl: recipe.photo,
                            categories: categoriesToShow,
                            onTap: () async {
                              // Navigator.of(context).pushNamed(
                              //     RecipeScreen.id,
                              //     arguments: recipe);
                              final result = await Navigator.of(context)
                                  .pushNamed(RecipeScreen.id,
                                      arguments: recipe);
                              if (result == true) {
                                // Update the UI if the favorites have changed
                                setState(() {
                                  readFavorites();
                                });
                              }
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  );
                }),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
