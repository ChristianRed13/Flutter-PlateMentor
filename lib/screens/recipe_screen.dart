import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/category_bloc/category_event.dart';
import 'package:plate_mentor/blocs/category_bloc/category_bloc.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_bloc.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_event.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_state.dart';
import 'package:plate_mentor/blocs/recipe_bloc/recipe_event.dart';
import 'package:plate_mentor/models/ingredient.dart';
import 'package:plate_mentor/models/user.dart';
import 'package:plate_mentor/repository/ingredient_repository.dart';
import 'package:plate_mentor/repository/user_repository.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../blocs/user_bloc/user_event.dart';
import '../blocs/user_bloc/user_state.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../repository/category_repository.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RecipeScreen extends StatefulWidget {
  static const id = 'recipe_screen';
  final Recipe recipe;

  RecipeScreen({required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final Recipe recipe;
  late List<Category> categories;
  late List<String> ingredientsRecipe;
  late final List<ChartData> chartData;
  bool startPage = true;
  late List<Ingredient> ingredients;
  Map<String, dynamic> groceries = {};
  Map<String, int> groceriesUnchecked = {};
  late final List<String> steps;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    chartData = [
      ChartData('Proteins', recipe.protein.toDouble(), Colors.red),
      ChartData('Carbs', recipe.carbs.toDouble(), Colors.green),
      ChartData('Fats', recipe.fats.toDouble(), Colors.orange),
    ];
    steps = recipe.steps;
    ingredientsRecipe = widget.recipe.ingredients.keys.toList();
    groceries = widget.recipe.ingredients;
    groceriesUnchecked = Map.from(widget.recipe.ingredients);
    //debug
    //print(groceriesUnchecked);
  }

  void updateUser(User user) {
    UserRepository(getStorage: GetStorage()).updateUser(user);
  }

  void _toggleChecked(Ingredient ingredient) {
    setState(() {
      ingredient.toggleChecked();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: UserRepository(getStorage: GetStorage())),
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

          if (state is UserLoadedFromToken) {
            User user = state.user;
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              body: BlocProvider<CategoryBloc>(
                create: (context) =>
                    CategoryBloc(categoryRepository: CategoryRepository()),
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    backgroundColor: Theme.of(context).primaryColorLight,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        widget.recipe.photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.36,
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            user.favorites.contains(recipe.id)
                                ? user.favorites.remove(recipe.id)
                                : user.favorites.add(recipe.id);
                            updateUser(user);
                          });
                          //toDo: toogle function to re-build and display if this recipe is
                          //favorite(fully filled icon) sau not favorite(only borders)
                          //toDo: add or remove from list of favorite recipes of the user
                        },
                        icon: Icon(
                          //toDo: Statefull widget ?
                          //toDo: if is in favorite list then display full favorite icon else only a border favorite icon
                          user.favorites.contains(recipe.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              //space between photo and next section
                              SizedBox(
                                height: 20,
                              ),
                              //title
                              Text(
                                '${recipe.title}',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //categories section by name and color
                              Container(
                                child: BlocBuilder<CategoryBloc, CategoryState>(
                                  builder: (context, state) {
                                    final categoryBloc =
                                        BlocProvider.of<CategoryBloc>(context);
                                    if (state is CategoryInitial) {
                                      categoryBloc.add(CategoriesByIds(
                                          ids: recipe.categories));
                                    }

                                    if (state is CategoryLoading) {
                                      return Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    }

                                    if (state is CategoryLoaded) {
                                      categoryBloc.add(CategoriesByIds(
                                          ids: recipe.categories));
                                    }

                                    if (state is CategoriesLoadedIds) {
                                      categories = state.categories;
                                      return Wrap(
                                        alignment: WrapAlignment.center,
                                        children: List.generate(
                                          categories.length,
                                          (index) {
                                            return Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: categories[index].color,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                categories[index].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.grey,
                                                      offset: Offset(1.0, 1.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }

                                    return Container(
                                      child: Text('Technical problems'),
                                    );
                                  },
                                ),
                              ),
                              //time & servings & ingredients
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 20, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                //best option, it works without
                                //height: MediaQuery.of(context).size.height * 0.155,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              ImageIcon(
                                                AssetImage('assets/knife.png'),
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Prep: ${recipe.preptime}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.soup_kitchen,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Cook: ${recipe.cooktime}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              //covered-plate-of-food.png
                                              ImageIcon(
                                                AssetImage(
                                                    'assets/covered-plate-of-food.png'),
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Servings: ${recipe.servings}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.shopping_cart,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Ingredients: ${recipe.ingredients.length}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //macros section
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 20, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Text(
                                        'Macros per serving',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SfCircularChart(
                                        margin: EdgeInsets.zero,
                                        annotations: <CircularChartAnnotation>[
                                          CircularChartAnnotation(
                                              widget: Text(
                                            '${recipe.calories} kcal',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          )),
                                        ],
                                        legend: Legend(
                                          alignment: ChartAlignment.center,
                                          overflowMode:
                                              LegendItemOverflowMode.scroll,
                                          isVisible: true,
                                          isResponsive: true,
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        series: <CircularSeries>[
                                          // Render pie chart
                                          DoughnutSeries<ChartData, String>(
                                              dataSource: chartData,
                                              innerRadius: '70%',
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              xValueMapper:
                                                  (ChartData data, _) =>
                                                      data.toString(),
                                              yValueMapper:
                                                  (ChartData data, _) =>
                                                      data.percentageY,
                                              explode: true,
                                              explodeIndex: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //ingredients list
                              //checked => nu adaugam in lista
                              //unchecked => adaugam in lista de cumparaturi
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 20, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Text(
                                        'Ingredients',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      //formula for ingredients space, first ingredient must have 100 space, the next ones must have 56
                                      height: 100.0 +
                                          56.0 * (ingredientsRecipe.length - 1),
                                      child: BlocProvider(
                                        create: (context) => IngredientBloc(
                                            ingredientRepository:
                                                IngredientRepository()),
                                        child: BlocBuilder<IngredientBloc,
                                            IngredientState>(
                                          builder: (context, state) {
                                            final ingredientBloc =
                                                BlocProvider.of<IngredientBloc>(
                                                    context);
                                            if (state
                                                is IngredientInitialState) {
                                              ingredientBloc.add(
                                                  LoadIngredientsRecipeEvent(
                                                      ingredientsId:
                                                          ingredientsRecipe));
                                            }

                                            if (state
                                                is IngredientLoadingState) {
                                              return Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            }

                                            if (state
                                                is IngredientLoadedState) {
                                              ingredientBloc.add(
                                                  LoadIngredientsRecipeEvent(
                                                      ingredientsId:
                                                          ingredientsRecipe));
                                            }

                                            if (state
                                                is IngredientRecipeLoadedState) {
                                              ingredients = state.ingredients;
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 20),
                                                child: ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: ingredients.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final ingredient =
                                                        ingredients[index];
                                                    return InkWell(
                                                      splashColor: Colors.grey,
                                                      onTap: () {
                                                        //to do.. sa isi aminteasca programul ce e checked cand se intoarce pe pagina
                                                        //_toggleChecked(ingredient);
                                                      },
                                                      child: Ink(
                                                        child: ListTile(
                                                          leading: Checkbox(
                                                            shape:
                                                                CircleBorder(),
                                                            value: ingredient
                                                                .isChecked,
                                                            onChanged: (value) {
                                                              _toggleChecked(
                                                                  ingredient);
                                                              if (value ==
                                                                  true) {
                                                                groceriesUnchecked
                                                                    .remove(
                                                                        ingredient
                                                                            .id);
                                                              } else {
                                                                final ingredientId =
                                                                    ingredient
                                                                        .id;

                                                                final quantity =
                                                                    groceries[
                                                                        ingredientId];

                                                                groceriesUnchecked[
                                                                        ingredientId] =
                                                                    quantity!;
                                                              }
                                                            },
                                                            activeColor: Theme
                                                                    .of(context)
                                                                .primaryColorLight,
                                                          ),
                                                          title: Text(
                                                            '${recipe.ingredients[ingredient.id]} ${ingredient.title}',
                                                            style: TextStyle(
                                                              decoration: ingredient
                                                                      .isChecked
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                            return Container(
                                              child: Text('error'),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    //buton adugat pe lista de ingrediente
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 40),
                                      child: CustomButton(
                                        onTap: () {
                                          print('Storage');
                                          print(GetStorage().read('groceries'));

                                          Map<String, dynamic>?
                                              storageGroceries =
                                              GetStorage().read('groceries');

                                          if (storageGroceries != null) {
                                            for (String id
                                                in groceriesUnchecked.keys) {
                                              storageGroceries[id] =
                                                  (storageGroceries[id] ?? 0) +
                                                      (groceriesUnchecked[id] ??
                                                          0);
                                            }

                                            print('Storage dupa update');
                                            print(storageGroceries);

                                            GetStorage().write(
                                                'groceries', storageGroceries);
                                          } else {
                                            GetStorage().write('groceries',
                                                groceriesUnchecked);
                                            print('Storage else');
                                            print(
                                                GetStorage().read('groceries'));
                                          }
                                        },
                                        text: 'Add to groceries',
                                        horizontalEdge: 80,
                                        edge: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //DEBUGG
                              // Container(
                              //   child: Text('${GetStorage().read('groceries') ?? ''}'),
                              // ),
                              //steps container
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Text(
                                        'Steps',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: steps.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}. ',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${steps[index]}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartData {
  final String nameX;
  final double percentageY;
  final Color color;

  ChartData(this.nameX, this.percentageY, this.color);

  @override
  String toString() {
    // TODO: implement toString
    return '${nameX}: ${percentageY}g';
  }
}

class GroceryItem {
  final String name;
  final String type;
  final String quantity;
  bool isChecked = false;

  GroceryItem({required this.name, required this.quantity, required this.type});

  void toggleChecked() {
    isChecked = !isChecked;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'name: ${name}';
  }
}
