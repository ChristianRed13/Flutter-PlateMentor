import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/widgets/custom_search_delegate_favorites.dart';

import '../blocs/recipe_bloc/recipe_bloc.dart';
import '../repository/recipe_repository.dart';
import '../screens/diet_plan_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/updates_screen.dart';
import '../widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../blocs/bloc_exports.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/my_flutter_app_icons.dart';
import 'favorites_screen.dart';
import 'groceries_screen.dart';
import 'my_drawer.dart';
import 'home_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);
  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _useMetrics = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Map<String, dynamic>> _pageDetails;

  void _toggleMetricSystem() {
    setState(() {
      _useMetrics = !_useMetrics;
      _pageDetails[3]['pageName'] = DietPlanScreen(
          useMetricSystem: _useMetrics, refreshCallBack: resetDiets);
    });
  }

  void resetForm() {
    GetStorage().write('form', true);
    print('resetForm');
    setState(() {
      _pageDetails[3]['pageName'] = DietPlanScreen(
          useMetricSystem: _useMetrics, refreshCallBack: resetDiets);
      _pageDetails[3]['appbar'] = CustomAppbar(
        title: 'Diet Plan',
        widgets: [
          IconButton(
            onPressed: _toggleMetricSystem,
            icon: Icon(
              MyIcons.weight_hanging,
            ),
          ),
          IconButton(
            onPressed: () {
              _showOptionsPopup(context);
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _pageDetails = [
      {
        'pageName': HomeScreen(),
        'appbar': CustomAppbar(
          title: 'Cookbook',
          widgets: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {
                _showOptionsPopup(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        )
      },
      {
        'pageName': FavoritesScreen(),
        'appbar': CustomAppbar(
          title: 'Favorites',
          widgets: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegateFavorites());
              },
              icon: Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {
                _showOptionsPopup(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        )
      },
      {
        'pageName': GroceriesScreen(
          refreshCallback: _refreshScreen,
        ),
        'appbar': CustomAppbar(
          title: 'Groceries',
          widgets: [
            IconButton(
              onPressed: () {
                _showDeletePopup(context);
              },
              icon: Icon(Icons.delete_forever),
            ),
            IconButton(
              onPressed: () {
                _showOptionsPopup(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        )
      },
      {
        'pageName': DietPlanScreen(
            useMetricSystem: _useMetrics, refreshCallBack: resetDiets),
        'appbar': CustomAppbar(
          title: 'Diet Plan',
          widgets: [
            showForm()
                ? IconButton(
                    onPressed: _toggleMetricSystem,
                    icon: Icon(
                      MyIcons.weight_hanging,
                    ),
                  )
                : IconButton(
                    onPressed: resetForm,
                    icon: Icon(
                      Icons.refresh,
                    ),
                  ),
            IconButton(
              onPressed: () {
                _showOptionsPopup(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        )
      },
    ];
  }

  var _selectedPageIndex = 0;

  void _refreshScreen() {
    // Refresh logic for GroceriesScreen goes here
    setState(() {});
  }

  void resetDiets() {
    setState(() {
      _pageDetails[3]['pageName'] = DietPlanScreen(
          useMetricSystem: _useMetrics, refreshCallBack: resetDiets);
      _pageDetails[3]['appbar'] = CustomAppbar(
        title: 'Diet Plan',
        widgets: [
          IconButton(
            onPressed: resetForm,
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              _showOptionsPopup(context);
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      );
    });
  }

  bool showForm() {
    if (GetStorage().read('form') != null) {
      print('show form: ${GetStorage().read('form')}');
      return GetStorage().read('form');
    }
    return false;
  }

  void _showDeletePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          var _storage = GetStorage();
                          Map<String, dynamic>? groceriesMap =
                              _storage.read('groceries');
                          List<String>? groceriesChecked =
                              _storage.read('groceriesChecked');
                          if (groceriesMap != null &&
                              groceriesChecked != null) {
                            groceriesChecked.forEach((checkedItem) {
                              groceriesMap.remove(checkedItem);
                            });
                            _storage.write('groceries', groceriesMap);
                            _storage.write('groceriesChecked', null);
                          }

                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Delete selected',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          var _storage = GetStorage();
                          _storage.write('groceries', null);
                          _storage.write('groceriesChecked', null);

                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Delete all',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      // Refresh the GroceriesScreen after the dialog is popped
      if (value == true) {
        setState(() {
          _pageDetails[2]['pageName'] = GroceriesScreen(
            refreshCallback: _refreshScreen,
          );
        });
      }
    });
  }

  void _showOptionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(SettingsScreen.id);
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(UpdatesScreen.id);
                        },
                        child: Text(
                          'Updates',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldKey,
      appBar: _pageDetails[_selectedPageIndex]['appbar'],
      drawer: MyDrawer(
        selectPage: (index) {
          selectPage(index);
          Navigator.of(context).pop();
        },
      ),
      body: _pageDetails[_selectedPageIndex]['pageName'],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                MyIcons.food_1,
              ),
              label: 'Cookbook'),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.favorite,
              ),
              label: 'Favorites'),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(MyIcons.shopping_basket),
              label: 'Groceries'),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(MyIcons.weight),
              label: 'Diet Generator'),
        ],
      ),
    );
  }
}
