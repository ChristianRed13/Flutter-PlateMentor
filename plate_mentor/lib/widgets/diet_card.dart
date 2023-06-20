import 'dart:io';

import 'package:plate_mentor/repository/category_repository.dart';
import 'package:plate_mentor/screens/recipe_screen.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/category_bloc/category_bloc.dart';
import '../blocs/category_bloc/category_event.dart';
import '../blocs/category_bloc/category_state.dart';
import '../models/recipe.dart';
import '../widgets/category_circle_item.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class DietCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTapFavorites;
  final VoidCallback onTap;
  final IconData icon;

  final double? size;

  const DietCard({
    required this.icon,
    required this.recipe,
    required this.onTapFavorites,
    required this.onTap,
    this.size,
  });

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryBloc(categoryRepository: CategoryRepository()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final categoryBloc = BlocProvider.of<CategoryBloc>(context);
          if (state is CategoryInitial) {
            categoryBloc.add(CategoriesByIds(ids: recipe.categories));
          }

          if (state is CategoryLoading) {
            return CircularProgressIndicator();
          }

          if (state is CategoryLoaded) {
            categoryBloc.add(CategoriesByIds(ids: recipe.categories));
          }

          if (state is CategoriesLoadedIds) {
            List<Category> categories = state.categories;
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  animationDuration: Duration(seconds: 2),
                  child: InkWell(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              left: 5,
                              child: InkWell(
                                onTap: onTapFavorites,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(3, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Ink(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width -
                                      MediaQuery.of(context).size.height *
                                          0.038 -
                                      MediaQuery.of(context).size.height * 0.04,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(recipe.photo),
                                    ),
                                  ),
                                ),
                                Ink(
                                  width: MediaQuery.of(context).size.height *
                                      0.065,
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: categories
                                        .map((category) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5, bottom: 10),
                                              child: CategoryCircleIcon(
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.047,
                                                color: category.color,
                                                iconData: category.imageUrl,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.58,
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, bottom: 5),

                              child: Text(
                                recipe.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.05,
                              padding: EdgeInsets.only(right: 50),
                              child: Text(
                                '${recipe.calories} kcal',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
