import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/bloc_exports.dart';
import 'package:plate_mentor/blocs/category_bloc/category_bloc.dart';
import 'package:plate_mentor/blocs/category_bloc/category_event.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_event.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_state.dart';
import 'package:plate_mentor/models/category.dart';
import 'package:plate_mentor/models/recipe.dart';
import 'package:plate_mentor/repository/category_repository.dart';
import 'package:plate_mentor/repository/recipe_repository.dart';
import 'package:plate_mentor/repository/user_repository.dart';
import 'package:plate_mentor/screens/recipe_screen.dart';
import 'package:plate_mentor/widgets/food_card.dart';

import '../blocs/user_bloc/user_bloc.dart';
import '../blocs/user_bloc/user_event.dart';
import '../blocs/user_bloc/user_state.dart';
import '../models/user.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({Key? key}) : super(key: key);

  static const id = 'favorites_screen';
  UserRepository userRepository = UserRepository(getStorage: GetStorage());

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favorites = [];

  void updateUserFavorites(List<String> myFavorites) {
    UserRepository(getStorage: GetStorage()).updateUserFavorites(myFavorites);
    writeFavorites(myFavorites);
    readFavorites();
    print('User favorites: $myFavorites');
  }

  @override
  void initState() {
    super.initState();
    if (GetStorage().read('favorites') != null) {
      List<dynamic> list = GetStorage().read('favorites');
      favorites = list.map((item) => item as String)!.toList();
    }
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

  Widget build(BuildContext context) {
    // Make sure to call super.build(context)

    //final userBloc = BlocProvider.of<UserBloc>(context);
    return BlocProvider(
      create: (context) => UserBloc(userRepository: widget.userRepository),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final userBloc = BlocProvider.of<UserBloc>(context);
          if (state is UserInitial) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UserLoading) {
            //return CircularProgressIndicator();
          }

          if (state is UserLoaded) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UpdateUserGroceries) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UpdateUserFavorites) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UserLoadedFromToken) {
            print('USER STATE IS THIS : ${state.user.favorites}');
            User user = state.user;
            user.favorites = List<String>.from(favorites as List);
            return user.favorites.isNotEmpty
                ? BlocProvider(
                    create: (context) =>
                        RecipeBloc(recipeRepository: RecipeRepository()),
                    child: BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        final recipeBloc = BlocProvider.of<RecipeBloc>(context);
                        if (state is RecipeInitial) {
                          recipeBloc.add(FetchRecipesById(ids: user.favorites));
                        }

                        if (state is RecipeLoading) {
                          // return CircularProgressIndicator();
                        }

                        if (state is RecipeLoaded) {
                          recipeBloc.add(FetchRecipesById(ids: user.favorites));
                        }

                        if (state is RecipesByIdLoaded) {
                          final List<Recipe> recipes = state.recipes;

                          // Render the recipes using the retrieved data
                          return GridView.count(
                            padding: EdgeInsets.all(5),
                            // crossAxisCount is the number of columns
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            // This creates two columns with two items in each column
                            children: List.generate(recipes.length, (index) {
                              return BlocProvider(
                                create: (context) => CategoryBloc(
                                    categoryRepository: CategoryRepository()),
                                child: BlocBuilder<CategoryBloc, CategoryState>(
                                  builder: (context, state) {
                                    final categoryBloc =
                                        BlocProvider.of<CategoryBloc>(context);
                                    if (state is CategoryInitial) {
                                      categoryBloc.add(CategoriesByIds(
                                          ids: recipes[index].categories));
                                    }

                                    if (state is CategoryLoading) {
                                      //return CircularProgressIndicator();
                                    }

                                    if (state is CategoryLoaded) {
                                      categoryBloc.add(CategoriesByIds(
                                          ids: recipes[index].categories));
                                    }

                                    if (state is CategoriesLoadedIds) {
                                      List<Category> categories =
                                          state.categories;
                                      return Center(
                                        child: FoodCard(
                                          icon: user.favorites
                                                  .contains(recipes[index].id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          onTapFavorites: () {
                                            user.favorites
                                                    .contains(recipes[index].id)
                                                ? user.favorites
                                                    .remove(recipes[index].id)
                                                : user.favorites
                                                    .add(recipes[index].id);
                                            updateUserFavorites(user.favorites);
                                            userBloc.add(UpdateUserFavorites(
                                                user: user));
                                          },
                                          name: recipes[index].title,
                                          imageUrl: recipes[index].photo,
                                          categories: categories,
                                          onTap: () async {
                                            final result =
                                                await Navigator.of(context)
                                                    .pushNamed(RecipeScreen.id,
                                                        arguments:
                                                            recipes[index]);
                                            if (result == true) {
                                              // Update the UI if the favorites have changed
                                              setState(() {
                                                userBloc
                                                    .add(FetchUserByToken());
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              );
                            }),
                          );
                        }

                        if (state is RecipeError) {
                          return Text(state.message);
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 100,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        Text(
                          'No Favorites Yet',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 20),
                        )
                      ],
                    ),
                  );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
