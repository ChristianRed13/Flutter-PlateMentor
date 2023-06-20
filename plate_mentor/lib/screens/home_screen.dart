import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/category_bloc/category_bloc.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_state.dart';
import 'package:plate_mentor/models/recipe.dart';
import 'package:plate_mentor/screens/category_screen.dart';
import 'package:plate_mentor/screens/quickest_screen.dart';
import 'package:plate_mentor/screens/updates_screen.dart';

import '../blocs/category_bloc/category_event.dart';
import '../blocs/recipe_bloc/recipe_event.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../widgets/details_card.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../models/data_categories.dart';
import 'most_popular_screen.dart';
import 'new_recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  static const cardHeight = 160.0;
  static const cardWidth = 120.0;

  const HomeScreen({Key? key}) : super(key: key);
  static const id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeInitial) {
          recipeBloc.add(FetchRecipes());
        }

        if (state is RecipeLoading) {
          return CircularProgressIndicator();
        }

        if (state is RecipeLoaded) {
          List<Recipe> recipes = state.recipes;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'News',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: screenSize.height * 0.3,
                  child: DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: TabBarView(
                      children: <Widget>[
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(NewRecipesScreen.id);
                            },
                            title: 'New Recipes',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {},
                            title: 'Diet Plans',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {
                              Navigator.of(context).pushNamed(UpdatesScreen.id);
                            },
                            title: 'Future Updates',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: screenSize.height * 0.3,
                  child: DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: TabBarView(
                      children: <Widget>[
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(MostPopularScreen.id);
                            },
                            title: '8 Most Popular',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {},
                            title: 'Pantry Analytics',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                        DetailsCard(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(QuickesRecipesScreen.id);
                            },
                            title: '5 Quickest Meals',
                            ImageUrl:
                                'https://images.unsplash.com/photo-1543668900-9124915a121f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //categories list
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryInitial) {
                      categoryBloc.add(FetchCategory());
                    }

                    if (state is CategoryLoading) {
                      return CircularProgressIndicator();
                    }

                    if (state is CategoriesLoadedIds) {
                      categoryBloc.add(FetchCategory());
                    }

                    if (state is CategoryLoaded) {
                      List<Category> categories = state.categories;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: ((categories.length / 3).ceil()) * cardHeight +
                            ((categories.length / 3).ceil() - 1) * 8,
                        child: GridView.count(
                          childAspectRatio: (cardWidth / cardHeight),
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: List.generate(
                            categories.length,
                            (index) {
                              Category category = categories.elementAt(index);
                              return CategoryCard(
                                width: cardWidth,
                                height: cardHeight,
                                name: category.title,
                                color: category.color,
                                iconData: category.imageUrl,
                                number: category.number,
                                onTap: () {
                                  //to do pagina de mancaruri cu categoria respectiva

                                  List<Recipe> categoryRecipes = recipes
                                      .where((recipe) => recipe.categories
                                          .contains(category.id))
                                      .toList();

                                  Navigator.of(context).pushNamed(
                                      CategoryScreen.id,
                                      arguments: [categoryRecipes, category]);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container(
                      child: Text('Tchnical problems'),
                    );
                  },
                ),
                SizedBox(
                  height: 10 % screenSize.height,
                ),
              ],
            ),
          );
        }
        return Container(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
