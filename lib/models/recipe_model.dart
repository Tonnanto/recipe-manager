import 'dart:typed_data';
import 'package:recipe_manager/models/recipe_detail_model.dart';

class Recipe {

  String name;

  List<Ingredient> ingredients = <Ingredient>[];
  List<PreparationStep> preparationSteps = <PreparationStep>[];
  List<RecipeType> recipeTypes = <RecipeType>[];
  List<Uint8List> images = <Uint8List>[];

  int preparationTime = 0;
  int cookingTime = 0;

  Recipe(this.name);

}
