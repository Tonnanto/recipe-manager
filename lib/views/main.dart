import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_detail_model.dart';
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
        recipeBooks: _getDemoRecipeBooks(),
      ),
    );
  }

  /// Returns some demo recipe books
  List<RecipeBook> _getDemoRecipeBooks() {

    RecipeBook recipeBook1 = RecipeBook("Antons Recipes", RecipeBookColor.banana, RecipeBookIcon.cooking_hat);
    recipeBook1.recipes.addAll(_getDemoRecipes());

    RecipeBook recipeBook2 = RecipeBook("Felix Recipe Book", RecipeBookColor.flora, RecipeBookIcon.ingredients);
    RecipeBook recipeBook3 = RecipeBook("Julia's Back Rezepte", RecipeBookColor.cantaloupe, RecipeBookIcon.dishes);
    RecipeBook recipeBook4 = RecipeBook("Kochbuch von Silke", RecipeBookColor.carnation, RecipeBookIcon.pan);
    RecipeBook recipeBook5 = RecipeBook("Holgers BBQ", RecipeBookColor.salmon, RecipeBookIcon.man);

    return [recipeBook1, recipeBook2, recipeBook3, recipeBook4, recipeBook5];
  }

  /// Returns some demo recipes
  List<Recipe> _getDemoRecipes() {

    Recipe recipe1 = Recipe("Bircher Müsli");
    recipe1.images = [
      Image.asset("")
    ];
    recipe1.ingredients = [
      Ingredient("Haferflocken", UnitAmount(Unit.GRAM, 150)),
      Ingredient("Sahne", UnitAmount(Unit.GRAM, 200)),
      Ingredient("Milch", UnitAmount(Unit.GRAM, 200)),
      Ingredient("Agaven Sirup oder Honig", UnitAmount(Unit.GRAM, 60)),
      Ingredient("Naturjoghurt", UnitAmount(Unit.GRAM, 150)),
      Ingredient("6-Korn-Mischung", UnitAmount(Unit.GRAM, 80)),
      Ingredient("Mandeln", UnitAmount(Unit.GRAM, 60)),
      Ingredient("Apfel", UnitAmount(Unit.PCS, 1)),
      Ingredient("Banane", UnitAmount(Unit.PCS, 2))
    ];
    recipe1.preparationSteps = [
      PreparationStep("Haferflocken mit Sahne, Milch, Agaven Sirup und Naturjoghurt mischen und über Nacht zugedeckt ziehen lassen."),
      PreparationStep("6-Korn-Mischung in den Thermomix geben und 20 Sekunden/Stufe 7 schroten. Mit kaltem Wasser bedeckt im Mixtopf über Nacht ziehen lassen."),
      PreparationStep("Morgens Mandeln zu den geschroteten Körnern geben und 3 Sekunden/Stufe 6 zerkleinern."),
      PreparationStep("Apfel und Bananen zugeben und 3 Sekunden/Stufe 5."),
      PreparationStep("Zum Schluss die Haferflocken-Mischung dazugeben und 15 Sekunden/Linkslauf/Stufe 3 mischen.")
    ];


    Recipe recipe2 = Recipe("Recipe 2");
    Recipe recipe3 = Recipe("Recipe 3");
    Recipe recipe4 = Recipe("Recipe 4");

    return [
      recipe1,
      recipe2,
      recipe3,
      recipe4
    ];
  }

}

