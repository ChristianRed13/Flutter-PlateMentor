import 'dart:async';

import 'package:flutter/material.dart';

import '../models/category.dart';
import 'category_circle_item.dart';
import 'custom_button.dart';

class CategoriesDropdown extends StatefulWidget {
  List<Category> optionsList;
  List<Category> addToCategories;

  CategoriesDropdown(
      {Key? key, required this.optionsList, required this.addToCategories})
      : super(key: key);

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  List<Category> addedToCategories = [];
  List<Category> optionsList = [];
  Category? addCategory = Category(
      title: '', imageUrl: '', color: Colors.white, number: 0, id: '0');
  Category? deleteCategory = null;
  List<DropdownMenuItem<Category>> dropdownItems = [];

  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //initiate the lists and the dropdownItems for the DropDownMenu
  @override
  void initState() {
    super.initState();
    optionsList = List.from(widget.optionsList);
    addedToCategories = widget.addToCategories;
    dropdownItems = optionsList
        .toSet()
        .map((category) => DropdownMenuItem<Category>(
              value: category,
              child: Text(category.title),
            ))
        .toList();
  }

  //removes category from addedToCategories and adds it back to widget.optionsList
  //so the user can choose it again
  void _removeCategory(Category category) {
    setState(() {
      addedToCategories.remove(category);
      widget.optionsList.add(category);
      //debug
      // print('widget.optionsList');
      // print(widget.optionsList);
    });
  }

  //adds category to addedToCategories list and deletes it from widget.optionsList
  void _addCategory(Category? selectedCategory) {
    print(optionsList);
    if (selectedCategory != null &&
        !addedToCategories.contains(selectedCategory) &&
        _doesExistByName(selectedCategory, widget.optionsList) &&
        selectedCategory.title.isNotEmpty) {
      setState(() {
        _removeExistingElementByName(selectedCategory, widget.optionsList);
        addedToCategories.add(selectedCategory);
        //debug
        // print('widget.optionsList');
        // print(widget.optionsList);
        // print('optionsList');
        // print(optionsList);
        // print('widget.addToCategories');
        // print(widget.addToCategories);
      });
    }
  }

  bool _doesExistByName(Category? category, List<Category> categories) {
    return categories.contains(category);
  }

  void _removeExistingElementByName(
      Category? category, List<Category> categories) {
    categories.remove(category);
  }

  @override
  Widget build(BuildContext context) {
    //timer
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.074,
              width: MediaQuery.of(context).size.width * 0.67,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<Category>(
                value: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: dropdownItems,
                onChanged: (Category? selectedCategory) {
                  setState(() {
                    if (selectedCategory != null) {
                      print(selectedCategory);
                      addCategory = selectedCategory;
                      print(addCategory);
                    }
                  });
                },
              ),
            ),
            CustomButton(
              onTap: () {
                setState(() {
                  print(addCategory);

                  _addCategory(addCategory);
                  print('in setState with addCategory');

                  print(widget.optionsList);
                });
              },
              text: 'Add',
              horizontalEdge: 8,
            ),
          ],
        ),
        SizedBox(height: 15),
        //show an empty box
        //or addedToCategories list of deletable icons
        addedToCategories.isEmpty
            ? SizedBox(
                height: 10,
              )
            : Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Wrap(
                      children: List.generate(
                        addedToCategories.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                //see if this clicked icon is ready to be deleted
                                //or initiate to be deleted if the users presses
                                //it in delete state (red with delete icon in it)
                                setState(() {
                                  if (deleteCategory ==
                                      addedToCategories.elementAt(index)) {
                                    //close timer, avoid memory leak
                                    timer?.cancel();
                                    deleteCategory = null;
                                    _removeCategory(
                                        addedToCategories.elementAt(index));
                                  } else {
                                    //close timer, to restart for the newly selected icom
                                    timer?.cancel();
                                    deleteCategory =
                                        addedToCategories.elementAt(index);

                                    // Start a new timer
                                    timer = deleteCategory != null
                                        ? Timer(Duration(seconds: 2), () {
                                            setState(() {
                                              deleteCategory = null;
                                            });
                                          })
                                        : null;
                                  }
                                });
                              },
                              child: CategoryCircleIcon(
                                size: 30,
                                //Verify if the icon is deletable and chage the appearance
                                //if it's not in the delete state, creates the category icon
                                color: deleteCategory ==
                                        addedToCategories.elementAt(index)
                                    ? Colors.red
                                    : addedToCategories.elementAt(index).color,
                                iconData: deleteCategory ==
                                        addedToCategories.elementAt(index)
                                    ? ''
                                    : addedToCategories
                                        .elementAt(index)
                                        .imageUrl,
                                icon: deleteCategory ==
                                        addedToCategories.elementAt(index)
                                    ? Icons.delete
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
        // Display the icons of selected categories
      ],
    );
  }
}
