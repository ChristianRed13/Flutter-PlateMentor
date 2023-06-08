import 'dart:ffi';

import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/category_bloc/category_bloc.dart';
import 'package:plate_mentor/blocs/category_bloc/category_state.dart';
import 'package:plate_mentor/models/recipe.dart';
import 'package:plate_mentor/models/user.dart';
import 'package:plate_mentor/repository/recipe_repository.dart';
import 'package:plate_mentor/repository/user_repository.dart';
import 'package:plate_mentor/screens/recipe_screen.dart';
import 'package:plate_mentor/widgets/categories_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/category_bloc/category_event.dart';
import '../blocs/recipe_bloc/recipe_bloc.dart';
import '../blocs/recipe_bloc/recipe_event.dart';
import '../blocs/recipe_bloc/recipe_state.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../blocs/user_bloc/user_event.dart';
import '../blocs/user_bloc/user_state.dart';
import '../models/data_categories.dart';
import '../models/category.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form.dart';
import '../widgets/diet_card.dart';

class DietPlanScreen extends StatefulWidget {
  static const id = 'diet_plan_screen';
  bool useMetricSystem;

  DietPlanScreen({super.key, required this.useMetricSystem});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  bool _useMetricSystem = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late List<Category> optionsList;
  List<Category> likedCategories = [];
  List<Category> dislikedCategories = [];
  // Set to false to use feet and inches
  Gender _gender = Gender.male;
  int _heightFt = 4; // Default height in feet
  int _heightIn = 1; // Default height in inches
  double intensity = 0;
  double? totalCalories = null;

  void initState() {
    super.initState();
    _useMetricSystem = widget.useMetricSystem;
    if (GetStorage().read('totalCalories') != null)
      totalCalories = double.tryParse(GetStorage().read('totalCalories'));
  }

  @override
  void didUpdateWidget(DietPlanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useMetricSystem != oldWidget.useMetricSystem) {
      setState(() {
        _useMetricSystem = widget.useMetricSystem;
      });
    }
  }

  void updateCalories() {
    if (verifyForm()) {
      setState(() {
        if (_useMetricSystem) {
          caloriesForGender();
        } else {
          _heightController.text =
              (30.48 * _heightFt + 2.54 * _heightIn).toString();
          _weightController.text = (0.45 *
                  double.parse(
                      _weightController.text.replaceAll(RegExp(r'lbs'), '')))
              .toString();
          caloriesForGender();
        }
      });
    }
    print(verifyForm());

    print('totalCalories: $totalCalories');
  }

  bool verifyForm() {
    if (!verifyHeight(double.parse(
            _heightController.text.replaceAll(RegExp(r'cm'), ''))) ||
        !verifyWeight(double.parse(
            _weightController.text.replaceAll(RegExp(r'kg'), ''))) ||
        !verifyAge(int.parse(_ageController.text))) {
      totalCalories = 0;
      return false;
    }

    return true;
  }

  bool verifyAge(int age) {
    if (age < 10 || age > 90) {
      return false;
    }
    return true;
  }

  bool verifyWeight(double weight) {
    if (_useMetricSystem) {
      if (weight < 40) {
        return false;
      }
      return true;
    } else {
      if (weight < 88.18) {
        return false;
      }
      return true;
    }
  }

  bool verifyHeight(double height) {
    if (height < 121) {
      return false;
    }
    return true;
  }

  void caloriesForGender() {
    if (_gender == Gender.male) {
      totalCalories = maleCalories() + maleCalories() * intensity;
    } else {
      totalCalories = femaleCalories() + femaleCalories() * intensity;
    }
  }

  double maleCalories() {
    return 10 *
            double.parse(_weightController.text.replaceAll(RegExp(r'kg'), '')) +
        6.25 *
            double.parse(_heightController.text.replaceAll(RegExp(r'cm'), '')) +
        5 * double.parse(_ageController.text) +
        5;
  }

  double femaleCalories() {
    return 10 *
            double.parse(_weightController.text.replaceAll(RegExp(r'kg'), '')) +
        6.25 *
            double.parse(_heightController.text.replaceAll(RegExp(r'cm'), '')) -
        5 * double.parse(_ageController.text) -
        161;
  }

  void updateUser(User user) {
    UserRepository(getStorage: GetStorage()).updateUser(user);
  }

  Widget build(BuildContext context) {
    //return
    //BlocBuilder<TasksBloc, TasksState>(
    // builder: (context, state) {
    //verificat daca exista deja retete bazate pe generator sau apare form-ul
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    print(_useMetricSystem);
    return BlocProvider(
      create: (context) => UserBloc(
        userRepository: UserRepository(getStorage: GetStorage()),
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final userBloc = BlocProvider.of<UserBloc>(context);
          if (state is UserInitial) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UserLoading) {
            return CircularProgressIndicator();
          }

          if (state is UserLoaded) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UpdateUserGroceries) {
            userBloc.add(FetchUserByToken());
          }

          if (state is UserLoadedFromToken) {
            User user = state.user;
            if (user.dietPlan.isNotEmpty || totalCalories != 0) {
              //dieta salvata deja
              List<String> userDietPlan = user.dietPlan;
              return BlocProvider(
                create: (context) =>
                    RecipeBloc(recipeRepository: RecipeRepository()),
                child: BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
                    if (state is RecipeInitial) {
                      recipeBloc.add(FetchRecipesById(ids: userDietPlan));
                    }

                    if (state is RecipeLoading) {
                      return CircularProgressIndicator();
                    }

                    if (state is RecipeLoaded) {
                      recipeBloc.add(FetchRecipesById(ids: userDietPlan));
                    }

                    if (state is RecipesByIdLoaded) {
                      List<Recipe> dietPlanRecipes = state.recipes;
                      print(dietPlanRecipes.length);
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: dietPlanRecipes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.all(15),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Meal ${index + 1}',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, right: 10),
                                            child: IconButton(
                                              iconSize: 30,
                                              onPressed: () {},
                                              icon: Icon(Icons.refresh),
                                            ),
                                          )
                                        ],
                                      ),
                                      DietCard(
                                        onTap: () async {
                                          final result = await Navigator.of(
                                                  context)
                                              .pushNamed(RecipeScreen.id,
                                                  arguments:
                                                      dietPlanRecipes[index]);
                                          if (result == true) {
                                            // Update the UI if the favorites have changed
                                            setState(() {
                                              userBloc.add(FetchUserByToken());
                                            });
                                          }
                                          ;
                                        },
                                        icon: user.favorites.contains(
                                                dietPlanRecipes[index].id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        onTapFavorites: () {
                                          setState(() {
                                            user.favorites.contains(
                                                    dietPlanRecipes[index].id)
                                                ? user.favorites.remove(
                                                    dietPlanRecipes[index].id)
                                                : user.favorites.add(
                                                    dietPlanRecipes[index].id);
                                            updateUser(user);
                                          });
                                        },
                                        recipe: dietPlanRecipes[index],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              );
            }
            //formularul
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryInitial) {
                  categoryBloc.add(FetchCategory());
                }

                if (state is CategoryLoading) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  );
                }

                if (state is CategoriesLoadedIds) {
                  categoryBloc.add(FetchCategory());
                }

                if (state is CategoryLoaded) {
                  optionsList = state.categories;

                  return SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/plate-mentor_logo.png',
                                height: 70,
                                width: 70,
                              ),
                            ),

                            //age
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Age',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            CustomTextForm(
                              border: Border.all(color: Colors.grey),
                              textInputType: TextInputType.number,
                              formKey: _formKey,
                              controller: _ageController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Age is required';
                                }
                                final int age = int.tryParse(value)!;
                                if (verifyAge(age)) {
                                  return 'Please enter an age between 10 and 90';
                                }

                                return null;
                              },
                              hintText: '10-90',
                            ),

                            //height (inches and feet OR cm)
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Height',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    bottom: 10,
                                    left: !_useMetricSystem ? 25 : 0),
                                alignment: Alignment.centerLeft,
                                child: _buildHeightMeasurementSystem(
                                    _useMetricSystem)),

                            //weight (lbs or kg)
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Weight',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            CustomTextForm(
                              textInputFormatter: SuffixTextFormatter(
                                  _useMetricSystem ? ' kg' : ' lbs'),
                              border: Border.all(color: Colors.grey),
                              textInputType: TextInputType.number,
                              formKey: _formKey,
                              controller: _weightController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Weight is required';
                                }
                                final int weight = int.tryParse(value)!;
                                //depending on lbs or kgs the condition must be lower then x of higher then y
                                if (_useMetricSystem
                                    ? (weight < 30 || weight > 300)
                                    : (weight < 90 || weight > 600)) {
                                  return 'Please enter a valid weight';
                                }
                                return null;
                              },
                              hintText: _useMetricSystem ? 'kg' : 'lbs',
                            ),
                            //intensity
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Activity Level',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 27, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: exerciceBuilder()),

                            //genders
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Genders',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                      activeColor:
                                          Theme.of(context).primaryColorLight,
                                      title: Text(
                                          'Male'), // add a non-null title argument
                                      value: Gender.male,
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                      activeColor:
                                          Theme.of(context).primaryColorLight,
                                      title: Text(
                                          'Female'), // add a non-null title argument
                                      value: Gender.female,
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                          print(_useMetricSystem);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //liked categroies
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Liked Categories',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10, left: 25),
                              child: CategoriesDropdown(
                                optionsList: optionsList,
                                addToCategories: likedCategories,
                              ),
                            ),
                            //disliked categroies
                            Container(
                              padding: EdgeInsets.only(
                                  top: 25, left: 30, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Disliked Categories',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10, left: 25),
                              child: CategoriesDropdown(
                                optionsList: optionsList,
                                addToCategories: dislikedCategories,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              child: CustomButton(
                                onTap: () {
                                  // to do: create diet, 3 meals besed on calories
                                  // validate data before generating diet
                                  //based on users list with recipes -> empty: diet form
                                  //                                 -> recipes present: recipe view
                                  //button for every recipe to get another recipe based on aprox same calories
                                  updateCalories();
                                },
                                text: 'Generate Diet',
                                horizontalEdge: 80,
                                edge: EdgeInsets.all(15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      //BUILD EXISTING MENU

                      );
                }
                return Container(
                  child: Text('Technical problems'),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
    //     },
//    );
  }

  Widget _buildHeightMeasurementSystem(bool isMetric) {
    return isMetric
        ? CustomTextForm(
            textInputFormatter: SuffixTextFormatter(' cm'),
            border: Border.all(color: Colors.grey),
            textInputType: TextInputType.number,
            formKey: _formKey,
            controller: _heightController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Height is required';
              }
              final double height = double.tryParse(value)!;
              if (verifyHeight(height)) {
                return 'Please enter a valid weight';
              }

              return null;
            },
            hintText: 'cm',
          )
        : _buildHeightDropdown();
  }

  Widget _buildHeightDropdown() {
    final List<int> ftValues = [4, 5, 6, 7, 8];
    final List<int> inValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

// Create copies of the lists with different references
    List<int> ftValuesCopy = List.from(ftValues);
    List<int> inValuesCopy = List.from(inValues);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            value: 4,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: ftValuesCopy.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString() + ' ft'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _heightFt = value!;
              });
            },
          ),
        ),
        SizedBox(width: 10),
        //
        //
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            value: 0,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: inValuesCopy.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString() + ' in'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _heightIn = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget exerciceBuilder() {
    final Map<String, double> intensities = {
      'Sedentary: little or no exercise': 0.2,
      'Exercise 1-3 times/week': 0.38,
      'Exercise 4-5 times/week': 0.46,
      'Daily exercise': 0.55
    };
    String? selectedOption =
        intensities.keys.first; // Variable to hold the selected option

    return Container(
      height: MediaQuery.of(context).size.height * 0.074,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedOption,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue!;
            intensity = intensities[selectedOption] ?? 0.0;
            print(intensity);
          });
        },
        items: intensities.keys.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class SuffixTextFormatter extends TextInputFormatter {
  final String suffix;

  SuffixTextFormatter(this.suffix);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String oldText = oldValue.text.replaceAll(suffix, '');
    final String newText = newValue.text.replaceAll(suffix, '');
    if (newText.endsWith(suffix)) {
      final int suffixIndex = newText.lastIndexOf(suffix);
      if (oldText == newText.substring(0, suffixIndex)) {
        // The number part of the text has not changed, so return the new value
        return newValue;
      }
    }

    final String formattedText = '$newText$suffix';
    final int selectionIndex = formattedText.length - suffix.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

enum Gender { male, female }
