import 'package:flutter/material.dart';
import 'package:plate_mentor/blocs/bloc_exports.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_state.dart';
import 'package:plate_mentor/screens/recipe_screen.dart';
import 'package:plate_mentor/widgets/details_card.dart';

import '../blocs/recipe_bloc/recipe_event.dart';
import '../models/recipe.dart';

class CustomSearchDelegate extends SearchDelegate {
  late List<Recipe> recipes;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    List<DetailsCard> matchQuery = [];
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeInitial) {
          recipeBloc.add(FetchRecipes());
        }

        if (state is RecipeLoading) {
          return CircularProgressIndicator();
        }

        if (state is RecipeLoaded) {
          recipes = state.recipes;

          for (var recipe in recipes) {
            if (recipe.title.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(
                DetailsCard(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  title: recipe.title,
                  ImageUrl: recipe.photo,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RecipeScreen.id, arguments: recipe);
                  },
                ),
              );
            }
          }
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              return matchQuery[index];
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    List<DetailsCard> matchQuery = [];
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeInitial) {
          recipeBloc.add(FetchRecipes());
        }

        if (state is RecipeLoading) {
          return CircularProgressIndicator();
        }

        if (state is RecipeLoaded) {
          recipes = state.recipes;

          for (var recipe in recipes) {
            if (recipe.title.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(
                DetailsCard(
                  margin: EdgeInsets.zero,
                  hideTitle: true,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.3,
                  title: recipe.title,
                  ImageUrl: recipe.photo,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RecipeScreen.id, arguments: recipe);
                  },
                ),
              );
            }
          }
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Card(
                  child: Row(children: [
                    matchQuery[index],
                    Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        '${matchQuery[index].title}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.visible),
                      ),
                    )
                  ]),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      hintColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
      ),
      appBarTheme: AppBarTheme(
        color: Theme.of(context).primaryColorLight,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey.shade200,
    );
  }
}
