import 'dart:convert';
import 'dart:typed_data';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:recipe_manager/models/ingredient_model.dart';


final String tableRecipes = 'recipes';

class Recipe {

  final String name;
  final int? id;

  final int recipeBookID;

  final List<String> preparationSteps;
  final List<RecipeType> recipeTypes;
  final Uint8List? image;

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
