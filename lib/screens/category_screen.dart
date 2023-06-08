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
import 'recipe_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const id = 'category_screen';

  CategoryScreen({
    required this.recipes,
    required this.category,
    Key? key,
  }) : super(key: key);

  final List<Recipe> recipes;
  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  void updateUser(User user) {
    UserRepository(getStorage: GetStorage()).updateUser(user);
  }

  void getUpdatedStorage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.title}'),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider<CategoryBloc>(
        create: (context) =>
            CategoryBloc(categoryRepository: CategoryRepository()),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final categoryBloc = BlocProvider.of<CategoryBloc>(context);
            if (state is CategoryInitial) {
              categoryBloc.add(FetchCategory());
            }

            if (state is CategoryLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is CategoryLoaded) {
              categoryBloc.add(CategoriesByIds(
                  ids: widget.recipes
                      .expand((recipe) => recipe.categories)
                      .toList()));
            }

            if (state is CategoriesLoadedIds) {
              List<Category> categories = state.categories;

              return GridView.count(
                padding: EdgeInsets.all(5),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: List.generate(
                  widget.recipes.length,
                  (index) {
                    final recipe = widget.recipes[index];
                    final categories = widget.recipes[index].categories;
                    return BlocProvider(
                      create: (context) => CategoryBloc(
                          categoryRepository: CategoryRepository()),
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

                            return BlocProvider(
                              create: (context) => UserBloc(
                                  userRepository:
                                      UserRepository(getStorage: GetStorage())),
                              child: BlocBuilder<UserBloc, UserState>(
                                builder: (context, state) {
                                  final userBloc =
                                      BlocProvider.of<UserBloc>(context);
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

                                  if (state is UserLoadedFromToken) {
                                    User user = state.user;

                                    return FoodCard(
                                      icon: user.favorites.contains(
                                              widget.recipes[index].id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      onTapFavorites: () {
                                        setState(() {
                                          user.favorites.contains(
                                                  widget.recipes[index].id)
                                              ? user.favorites.remove(
                                                  widget.recipes[index].id)
                                              : user.favorites.add(
                                                  widget.recipes[index].id);
                                          updateUser(user);
                                        });
                                      },
                                      name: recipe.title,
                                      imageUrl: recipe.photo,
                                      categories: categoriesToShow,
                                      onTap: () async {
                                        // Navigator.of(context).pushNamed(
                                        //     RecipeScreen.id,
                                        //     arguments: recipe);
                                        final result =
                                            await Navigator.of(context)
                                                .pushNamed(RecipeScreen.id,
                                                    arguments: recipe);
                                        if (result == true) {
                                          // Update the UI if the favorites have changed
                                          setState(() {
                                            userBloc.add(FetchUserByToken());
                                          });
                                        }
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// class CategoryScreenBody extends StatelessWidget {
//   final List<Recipe> recipes;
//   final Category category;
//   const CategoryScreenBody({
//     Key? key,
//     required this.recipes,
//     required this.category,
//   }) : super(key: key);

//   void updateUser(User user) {
//     UserRepository(getStorage: GetStorage()).updateUser(user);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final categoryBloc = BlocProvider.of<CategoryBloc>(context);
//     return BlocBuilder<CategoryBloc, CategoryState>(
//       builder: (context, state) {
//         if (state is CategoryInitial) {
//           categoryBloc.add(FetchCategory());
//         }

//         if (state is CategoryLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (state is CategoryLoaded) {
//           categoryBloc.add(CategoriesByIds(
//               ids: recipes.expand((recipe) => recipe.categories).toList()));
//         }

//         if (state is CategoriesLoadedIds) {
//           List<Category> categories = state.categories;

//           return GridView.count(
//             padding: EdgeInsets.all(5),
//             crossAxisCount: 2,
//             mainAxisSpacing: 5,
//             crossAxisSpacing: 5,
//             children: List.generate(
//               recipes.length,
//               (index) {
//                 final recipe = recipes[index];
//                 final categories = recipes[index].categories;
//                 return BlocProvider(
//                   create: (context) =>
//                       CategoryBloc(categoryRepository: CategoryRepository()),
//                   child: BlocBuilder<CategoryBloc, CategoryState>(
//                     builder: (context, state) {
//                       final categoryBlocSecond =
//                           BlocProvider.of<CategoryBloc>(context);
//                       if (state is CategoryInitial) {
//                         categoryBlocSecond.add(
//                           CategoriesByIds(ids: categories),
//                         );
//                       }

//                       if (state is CategoryLoading) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       if (state is CategoryLoaded) {
//                         categoryBlocSecond.add(
//                           CategoriesByIds(ids: categories),
//                         );
//                       }

//                       if (state is CategoriesLoadedIds) {
//                         List<Category> categoriesToShow = state.categories;

//                         return BlocProvider(
//                           create: (context) => UserBloc(
//                               userRepository:
//                                   UserRepository(getStorage: GetStorage())),
//                           child: BlocBuilder<UserBloc, UserState>(
//                             builder: (context, state) {
//                               final userBloc =
//                                   BlocProvider.of<UserBloc>(context);
//                               if (state is UserInitial) {
//                                 userBloc.add(FetchUserByToken());
//                               }

//                               if (state is UserLoading) {
//                                 //return CircularProgressIndicator();
//                               }

//                               if (state is UserLoaded) {
//                                 userBloc.add(FetchUserByToken());
//                               }

//                               if (state is UpdateUserGroceries) {
//                                 userBloc.add(FetchUserByToken());
//                               }

//                               if (state is UserLoadedFromToken) {
//                                 User user = state.user;

//                                 return FoodCard(
//                                   icon:
//                                       user.favorites.contains(recipes[index].id)
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                   onTapFavorites: () {
//                                     user.favorites.contains(recipes[index].id)
//                                         ? user.favorites
//                                             .remove(recipes[index].id)
//                                         : user.favorites.add(recipes[index].id);
//                                     updateUser(user);
//                                   },
//                                   name: recipe.title,
//                                   imageUrl: recipe.photo,
//                                   categories: categoriesToShow,
//                                   onTap: () {
//                                     Navigator.of(context).pushNamed(
//                                         RecipeScreen.id,
//                                         arguments: recipe);
//                                   },
//                                 );
//                               }
//                               return Container();
//                             },
//                           ),
//                         );
//                       }
//                       return Container();
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         }

//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
