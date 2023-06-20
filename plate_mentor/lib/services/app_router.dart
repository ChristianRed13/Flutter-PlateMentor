import 'package:plate_mentor/screens/category_screen.dart';

import '../models/category.dart';
import '../screens/most_popular_screen.dart';
import '../screens/new_recipes_screen.dart';
import '../screens/quickest_screen.dart';
import '../screens/recipe_screen.dart';

import '../models/recipe.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/recycle_bin.dart';
import '../screens/settings_screen.dart';
import '../screens/tabs_screen.dart';
import '../screens/updates_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case QuickesRecipesScreen.id:
        return MaterialPageRoute(
          builder: (_) => QuickesRecipesScreen(),
        );
      case MostPopularScreen.id:
        return MaterialPageRoute(
          builder: (_) => MostPopularScreen(),
        );
      case NewRecipesScreen.id:
        return MaterialPageRoute(
          builder: (_) => NewRecipesScreen(),
        );
      case CategoryScreen.id:
        final List<dynamic> arguments =
            routeSettings.arguments as List<dynamic>;
        final List<Recipe> recipes = arguments[0] as List<Recipe>;
        final Category category = arguments[1] as Category;

        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            recipes: recipes,
            category: category,
          ),
        );
      case UpdatesScreen.id:
        return MaterialPageRoute(
          builder: (_) => UpdatesScreen(),
        );
      case ForgotPasswordScreen.id:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case SettingsScreen.id:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (_) => const RecycleBin(),
        );
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (_) => const TabsScreen(),
        );
      case RegisterScreen.id:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case LoginScreen.id:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case RecipeScreen.id:
        // extract the recipe data passed as arguments
        final Recipe recipe = routeSettings.arguments as Recipe;
        // return a MaterialPageRoute with RecipeScreen and pass the recipe data
        return MaterialPageRoute(
          builder: (_) => RecipeScreen(recipe: recipe),
        );
      default:
        //default error page needed
        return null;
    }
  }
}
