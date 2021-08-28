import 'dart:convert';
import 'dart:typed_data';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/utilities/persistence.dart';


final String tableRecipes = 'recipes';

class Recipe {

  final String name;
  final int? id;

  final int recipeBookID;

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
      this.ingredients = await PersistenceService.instance.readIngredientsFromRecipe(this.id!);
    }
    return ingredients;
  }

  /// Updates the database with new ingredients for this recipe
  Future<Iterable<Ingredient>> updateIngredients(Iterable<Ingredient> newIngredients) async {
    Iterable<int> oldIngredientIds = (await loadIngredients()).map((e) => e.id!);

    // Update and add new ingredients
    for (Ingredient ingredient in newIngredients) {
      if (ingredient.id != null && oldIngredientIds.contains(ingredient.id!)) {
        // If id is known -> update ingredient in db
        await PersistenceService.instance.updateIngredient(ingredient.copy(recipeID: this.id));

      } else {
        // If id is unknown or no id created yet -> add ingredient to db
        await PersistenceService.instance.createIngredient(ingredient.copy(recipeID: this.id));
      }
    }

    // Delete old ingredients that are not in newIngredients
    for (int oldIngredientId in oldIngredientIds) {
      if (!newIngredients.map((e) => e.id).contains(oldIngredientId)) {
        PersistenceService.instance.deleteIngredient(oldIngredientId);
      }
    }

    return newIngredients;
  }

  static Recipe fromMap(Map<String, Object?> map) {

    List<String> recipeTypeStrings = (map[RecipeFields.recipeTypes] as String).split(recipeTypeSeparator);
    String imageString = map[RecipeFields.image] as String;

    return Recipe(
      id: map[RecipeFields.id] as int?,
      name: map[RecipeFields.name] as String,
      recipeBookID: map[RecipeFields.recipeBookID] as int,
      preparationSteps: (map[RecipeFields.preparationSteps] as String).split(prepStepSeparator),
      recipeTypes: List.generate(recipeTypeStrings.length, (index) => EnumToString.fromString(RecipeType.values, recipeTypeStrings[index]) ?? RecipeType.OTHER),
      image: imageString.isNotEmpty ? Base64Decoder().convert(imageString) : null,
      preparationTime: map[RecipeFields.preparationTime] as int,
      cookingTime: map[RecipeFields.cookingTime] as int,
    );
  }

  Map<String, Object?> toMap() => {
    RecipeFields.id: id,
    RecipeFields.name: name,
    RecipeFields.preparationSteps: preparationSteps.join(prepStepSeparator),
    RecipeFields.recipeTypes: (List.generate(recipeTypes.length, (index) => EnumToString.convertToString(recipeTypes[index]))).join(recipeTypeSeparator),
    RecipeFields.image: image != null ? Base64Encoder().convert(image!) : "",
    RecipeFields.preparationTime: preparationTime,
    RecipeFields.cookingTime: cookingTime,
    RecipeFields.recipeBookID: recipeBookID,
  };

  /// Returns a copy of the same Recipe with the given fields changed
  Recipe copy({
    int? id,
    String? name,
    List<String>? preparationSteps,
    List<RecipeType>? recipeTypes,
    Uint8List? image,
    int? preparationTime,
    int? cookingTime,
    int? recipeBookID,
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
  MAIN_DISH, DESSERT, APPETIZER, MEAT, VEGETARIAN, VEGAN, COOKING, BAKING, PASTRY, DRINK, OTHER
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
