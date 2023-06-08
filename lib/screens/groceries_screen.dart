import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_bloc.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_state.dart';
import 'package:plate_mentor/models/ingredient.dart';
import 'package:plate_mentor/repository/ingredient_repository.dart';
import 'package:plate_mentor/repository/user_repository.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/ingredient_bloc/ingredient_event.dart';
import '../models/user.dart';
import '../widgets/my_flutter_app_icons.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({Key? key}) : super(key: key);
  static const id = 'groceries_screen';

  @override
  _GroceriesScreenState createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  GetStorage _storage = GetStorage();
  Map<String, dynamic>? groceriesMap = {};
  Map<String, List<Ingredient>> groceriesGrouped = {};
  List<Ingredient> ingredients = [];
  @override
  void initState() {
    super.initState();
    groceriesMap = _storage.read('groceries');
  }

  void readGroceriesFromMemory() {
    groceriesMap = _storage.read('groceries');
  }

  void _toggleChecked(Ingredient ingredient) {
    setState(() {
      ingredient.toggleChecked();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (groceriesMap == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MyIcons.shopping_basket,
              size: 100,
              color: Theme.of(context).primaryColorLight,
            ),
            Text(
              'Empty groceries',
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight, fontSize: 20),
            )
          ],
        ),
      );
    }
    return BlocProvider(
      create: (context) =>
          IngredientBloc(ingredientRepository: IngredientRepository()),
      child: BlocBuilder<IngredientBloc, IngredientState>(
        builder: (context, state) {
          final ingredientBloc = BlocProvider.of<IngredientBloc>(context);

          print(groceriesMap);

          if (state is IngredientInitialState) {
            ingredientBloc.add(LoadIngredientsRecipeEvent(
                ingredientsId: groceriesMap!.keys.toList()));
          }

          if (state is IngredientLoadingState) {
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColorLight,
              body: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              ),
            );
          }

          if (state is IngredientLoadedState) {
            ingredientBloc.add(LoadIngredientsRecipeEvent(
                ingredientsId: groceriesMap!.keys.toList()));
          }

          if (state is IngredientRecipeLoadedState) {
            ingredients = state.ingredients;

            print(ingredients);
            groceriesGrouped.clear(); // Clear the map before adding items
            groceriesMap = _storage.read('groceries');
            print(groceriesMap);

            ingredients.forEach((item) {
              if (groceriesGrouped.containsKey(item.type)) {
                if (!groceriesGrouped[item.type]!.contains(item)) {
                  groceriesGrouped[item.type]!.add(item);
                }
              } else {
                groceriesGrouped[item.type] = [item];
              }
            });

            return ListView.builder(
              itemCount: groceriesGrouped.length,
              itemBuilder: (context, index) {
                final type = groceriesGrouped.keys.toList()[index];
                final groceriesByType = groceriesGrouped[type];
                return Ink(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 25, left: 20),
                        child: Text(
                          type,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        indent: 20,
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groceriesByType!.length,
                        itemBuilder: (context, index) {
                          final grocery = groceriesByType[index];
                          return InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              //to do.. sa isi aminteasca programul ce e checked cand se intoarce pe pagina
                              _toggleChecked(grocery);
                            },
                            child: Ink(
                              child: ListTile(
                                leading: Checkbox(
                                  value: grocery.isChecked,
                                  onChanged: (value) {
                                    _toggleChecked(grocery);
                                  },
                                  activeColor:
                                      Theme.of(context).primaryColorLight,
                                ),
                                title: Text(
                                  '${groceriesMap![grocery.id]} ${grocery.title}',
                                  style: TextStyle(
                                    decoration: grocery.isChecked
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
