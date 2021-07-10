
import 'package:recipe_manager/models/recipe_model.dart';

class RecipeBook {
  String name;
  List<Recipe> recipes = <Recipe>[];

  RecipeBook(this.name);
}