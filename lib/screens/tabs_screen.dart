import 'package:flutter/services.dart';
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
      _pageDetails[3]['pageName'] =
          DietPlanScreen(useMetricSystem: _useMetrics);
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
        'pageName': GroceriesScreen(),
        'appbar': CustomAppbar(
          title: 'Groceries',
          widgets: [
            IconButton(
              onPressed: () {
                _showDeletePopup(context);
              },
              icon: Icon(Icons.delete),
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
        'pageName': DietPlanScreen(useMetricSystem: _useMetrics),
        'appbar': CustomAppbar(
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
        )
      },
    ];
  }

  var _selectedPageIndex = 0;

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
                          _selectedPageIndex = 2;
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
                          _selectedPageIndex = 2;
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
    );
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

  void _addTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const HomeScreen(),
              ),
            ));
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
