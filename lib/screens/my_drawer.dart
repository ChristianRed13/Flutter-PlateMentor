import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/repository/category_repository.dart';

import '../blocs/category_bloc/category_bloc.dart';
import '../blocs/category_bloc/category_event.dart';
import '../blocs/recipe_bloc/recipe_bloc.dart';
import '../blocs/recipe_bloc/recipe_event.dart';
import '../blocs/recipe_bloc/recipe_state.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../widgets/category_circle_item.dart';
import '../widgets/my_flutter_app_icons.dart';

import '../blocs/bloc_exports.dart';
import '../models/data_categories.dart';
import 'category_screen.dart';
import 'login_screen.dart';

class MyDrawer extends StatelessWidget {
  static const double logoHeight = 100;
  static const double categoryIconHeight = 55;
  final Function(int) selectPage;
  MyDrawer({
    Key? key,
    required this.selectPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //logo icon & bar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
                color: Theme.of(context).primaryColorLight,
                child: Container(
                  height: logoHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Image(
                    image: new AssetImage('assets/plate-mentor_logo.png'),
                    width: logoHeight,
                    height: logoHeight,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //cookbook
              MainScreensButtons(
                categoryIconHeight: categoryIconHeight,
                title: 'Cookbook',
                iconData: MyIcons.food_1,
                onTap: () {
                  selectPage(0);
                },
              ),
              //favorites

              MainScreensButtons(
                categoryIconHeight: categoryIconHeight,
                title: 'Favorites',
                iconData: Icons.favorite,
                onTap: () {
                  selectPage(1);
                },
              ),
              //groceries

              MainScreensButtons(
                categoryIconHeight: categoryIconHeight,
                title: 'Groceries',
                iconData: MyIcons.shopping_basket,
                onTap: () {
                  selectPage(2);
                },
              ),
              //Diet Plan
              MainScreensButtons(
                categoryIconHeight: categoryIconHeight,
                title: 'Diet Plan',
                iconData: MyIcons.weight,
                onTap: () {
                  selectPage(3);
                },
              ),

              SizedBox(
                height: 15,
              ),

              //list of categories
              BlocProvider(
                create: (context) =>
                    CategoryBloc(categoryRepository: CategoryRepository()),
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
                    if (state is CategoryInitial) {
                      categoryBloc.add(FetchCategory());
                    }

                    // if (state is CategoryLoading) {
                    //   return CircularProgressIndicator();
                    // }

                    if (state is CategoriesLoadedIds) {
                      categoryBloc.add(FetchCategory());
                    }

                    if (state is CategoryLoaded) {
                      List<Category> categories = state.categories;
                      return Container(
                        height:
                            (categoryIconHeight + 20) * categories.length + 10,
                        child: ListView.builder(
                          itemCount: categories.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return BlocBuilder<RecipeBloc, RecipeState>(
                              builder: (context, state) {
                                final recipeBloc =
                                    BlocProvider.of<RecipeBloc>(context);
                                if (state is RecipeInitial) {
                                  recipeBloc.add(FetchRecipes());
                                }

                                if (state is RecipeLoading) {
                                  return CircularProgressIndicator();
                                }

                                if (state is RecipeLoaded) {
                                  List<Recipe> recipes = state.recipes;
                                  return InkWell(
                                    onTap: () {
                                      List<Recipe> categoryRecipes = recipes
                                          .where((recipe) => recipe.categories
                                              .contains(categories[index].id))
                                          .toList();
                                      //print(categoryRecipes);

                                      Navigator.of(context).pushNamed(
                                          CategoryScreen.id,
                                          arguments: [
                                            categoryRecipes,
                                            categories[index]
                                          ]);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CategoryCircleIcon(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 15),
                                            size: categoryIconHeight,
                                            color: categories[index].color,
                                            iconData:
                                                categories[index].imageUrl,
                                          ),
                                          Text(
                                            categories[index].title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              //LOGOUT
              Divider(
                thickness: 3,
                color: Theme.of(context).primaryColorLight,
              ),
              MainScreensButtons(
                categoryIconHeight: categoryIconHeight,
                title: 'Logout',
                iconData: Icons.logout,
                onTap: () {
                  GetStorage().remove('token');
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreensButtons extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  const MainScreensButtons({
    super.key,
    required this.categoryIconHeight,
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final double categoryIconHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).primaryColorLight, // Button color
                child: SizedBox(
                  width: categoryIconHeight,
                  height: categoryIconHeight,
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: categoryIconHeight / 1.5,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


              //setting the theme dark/light
              // BlocBuilder<SwitchBloc, SwitchState>(
              //   builder: (context, state) {
              //     return Switch(
              //       value: state.switchValue,
              //       onChanged: (newValue) {
              //         newValue
              //             ? context.read<SwitchBloc>().add(SwitchOnEvent())
              //             : context.read<SwitchBloc>().add(SwitchOffEvent());
              //       },
              //     );
              //   },
              // ),