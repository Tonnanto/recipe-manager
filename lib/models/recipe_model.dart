import 'dart:typed_data';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';


final String tableRecipes = 'recipes';

class Recipe {

  final String name;
  final String? id;

  final String recipeBookID;

  final List<String> preparationSteps;
  final List<RecipeType> recipeTypes;
  Uint8List? image;

  final int preparationTime;
  final int cookingTime;

  List<Ingredient> ingredients = <Ingredient>[];
  static final prepStepSeparator = ' // ';
  static final recipeTypeSeparator = ' // ';

  Recipe({
    this.id,
    required this.name,
    required this.preparationSteps,
    required this.recipeTypes,
    required this.image,
    required this.preparationTime,
    required this.cookingTime,
    required this.recipeBookID
  });

  /// Updates the ingredients field with data from the database
  Future<List<Ingredient>> loadIngredients() async {
    if (this.id != null) {
      this.ingredients = await DataService.instance.readIngredientsFromRecipe(this);
    }
    return ingredients;
  }

  /// Updates the database with new ingredients for this recipe
  Future<Iterable<Ingredient>> updateIngredients(Iterable<Ingredient> newIngredients) async {
    Iterable<String> oldIngredientIds = (await loadIngredients()).map((e) => e.id!);

    // Update and add new ingredients
    for (Ingredient ingredient in newIngredients) {
      if (ingredient.id != null && oldIngredientIds.contains(ingredient.id!)) {
        // If id is known -> update ingredient in db
        await DataService.instance.updateIngredient(ingredient.copy(recipeID: this.id), this);

      } else {
        // If id is unknown or no id created yet -> add ingredient to db
        await DataService.instance.createIngredient(ingredient.copy(recipeID: this.id), this);
      }
    }

    // Delete old ingredients that are not in newIngredients
    for (String oldIngredientId in oldIngredientIds) {
      if (!newIngredients.map((e) => e.id).contains(oldIngredientId)) {
        DataService.instance.deleteIngredient(oldIngredientId, this);
      }
    }

    return newIngredients;
  }

  /// Returns a copy of the same Recipe with the given fields changed
  Recipe copy({
    String? id,
    String? name,
    List<String>? preparationSteps,
    List<RecipeType>? recipeTypes,
    Uint8List? image,
    int? preparationTime,
    int? cookingTime,
    String? recipeBookID,
  }) {
    Recipe copy = Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      preparationSteps: preparationSteps ?? this.preparationSteps,
      recipeTypes: recipeTypes ?? this.recipeTypes,
      image: image ?? this.image,
      preparationTime: preparationTime ?? this.preparationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      recipeBookID: recipeBookID ?? this.recipeBookID,
    );
    copy.ingredients = this.ingredients;
    return copy;
  }
}

class RecipeFields {
  static final List<String> values = [
    id, name, preparationSteps, recipeTypes, image, preparationTime, cookingTime, recipeBookID
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String preparationSteps = 'preparationSteps';
  static final String recipeTypes = 'recipeTypes';
  static final String image = 'image';
  static final String preparationTime = 'preparationTime';
  static final String cookingTime = 'cookingTime';
  static final String recipeBookID = 'recipeBookID'; // Foreign Key
}


/// A recipe can have multiple types.
/// Types can be used to filter recipes when searching
enum RecipeType {
  MAIN_DISH, DESSERT, APPETIZER, SNACK, MEAT, VEGETARIAN, VEGAN, COOKING, BAKING, PASTRY, DRINK, SAUCE_DIP, THERMOMIX, OTHER
}

extension RecipeTypeExtension on RecipeType {
  String name() {
    switch (this) {
      case RecipeType.MAIN_DISH:
        return 'Main Dish';
      case RecipeType.DESSERT:
        return 'Dessert';
      case RecipeType.APPETIZER:
        return 'Appetizer';
      case RecipeType.MEAT:
        return 'Meat';
      case RecipeType.VEGETARIAN:
        return 'Vegetarian';
      case RecipeType.VEGAN:
        return 'Vegan';
      case RecipeType.COOKING:
        return 'Cooking';
      case RecipeType.BAKING:
        return 'Baking';
      case RecipeType.PASTRY:
        return 'Pastry';
      case RecipeType.DRINK:
        return 'Drink';
      case RecipeType.SNACK:
        return 'Snack';
      case RecipeType.SAUCE_DIP:
        return 'Sauce / Dip';
      case RecipeType.THERMOMIX:
        return 'Thermomix';
      case RecipeType.OTHER:
        return 'Other';
    }
  }
}

/// This class is only used so a ObjectKey can be used on Preparation Steps.
/// A recipe stores preparation steps as List<String>
class PreparationStep {
  String content = '';
  PreparationStep({required this.content});

  static List<PreparationStep> fromStrings(List<String> strings) {
    return List.generate(strings.length, (index) => PreparationStep(content: strings[index]));
  }

  static List<String> toStrings(List<PreparationStep> prepSteps) {
    return List.generate(prepSteps.length, (index) => prepSteps[index].content);
  }
}
