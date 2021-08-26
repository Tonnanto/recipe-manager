import 'package:flutter/material.dart';
import 'package:recipe_manager/utilities/persistence.dart';
import 'package:recipe_manager/views/recipe_book_list_page.dart';

void main() {
  runApp(RecipeManagerApp());
}

class RecipeManagerApp extends StatelessWidget {
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
      home: RecipeBookListPage(),
    );
  }
}


