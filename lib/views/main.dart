import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/views/recipe_book_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Manager',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryTextTheme: TextTheme(
            // White AppBar Text
            headline6: TextStyle(
                color: Colors.white
            )
        )
      ),
      home: RecipeBookList(
        title: 'My Recipe Books',
        recipeBooks: _getTestRecipeBooks(),
      ),
    );
  }

  /// Returns some demo recipe books
  List<RecipeBook> _getTestRecipeBooks() {

    RecipeBook recipeBook1 = RecipeBook("Antons Recipes");
    recipeBook1.recipes.addAll([
      Recipe("Recipe 1"),
      Recipe("Recipe 2"),
      Recipe("Recipe 3"),
    ]);

    RecipeBook recipeBook2 = RecipeBook("Felix Recipe Book");

    return <RecipeBook>[
      recipeBook1,
      recipeBook2
    ];
  }
}

