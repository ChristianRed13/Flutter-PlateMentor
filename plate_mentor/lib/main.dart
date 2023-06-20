import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plate_mentor/blocs/ingredient_bloc/ingredient_bloc.dart';
import 'package:plate_mentor/repository/ingredient_repository.dart';
import '../firebase_options.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/bloc_exports.dart';
import 'blocs/category_bloc/category_bloc.dart';
import 'blocs/recipe_bloc/recipe_bloc.dart';
import 'repository/category_repository.dart';
import 'repository/recipe_repository.dart';
import 'screens/tabs_screen.dart';
import 'services/app_router.dart';
import 'services/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MyApp(
      appRouter: AppRouter(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(create: (context) => SwitchBloc()),
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc(
            recipeRepository: RecipeRepository(),
          ),
        ),
        BlocProvider<IngredientBloc>(
          create: (context) => IngredientBloc(
            ingredientRepository: IngredientRepository(),
          ),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          ),
        ),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          //update categories number
          CategoryRepository().updateNumbers();

          //run app
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            home: const SplashScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
