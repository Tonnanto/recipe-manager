import 'dart:convert';
import 'dart:typed_data';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:recipe_manager/models/recipe_detail_model.dart';


final String tableRecipeBooks = 'recipes';

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

    List<String> recipeTypeStrings = (map[RecipeFields.recipeTypes] as String).split(", ");
    String imageString = map[RecipeFields.image] as String;

    return Recipe(
      id: map[RecipeFields.id] as int?,
      name: map[RecipeFields.name] as String,
      recipeBookID: map[RecipeFields.recipeBookID] as int,
      preparationSteps: (map[RecipeFields.preparationSteps] as String).split(", "),
      recipeTypes: List.generate(recipeTypeStrings.length, (index) => EnumToString.fromString(RecipeType.values, recipeTypeStrings[index]) ?? RecipeType.OTHER),
      image: imageString.isNotEmpty ? Base64Decoder().convert(imageString) : null,
      preparationTime: map[RecipeFields.preparationTime] as int,
      cookingTime: map[RecipeFields.cookingTime] as int,
    );
  }

  Map<String, Object?> toMap() => {
    RecipeFields.id: id,
    RecipeFields.name: name,
    RecipeFields.preparationSteps: preparationSteps,
    RecipeFields.recipeTypes: recipeTypes,
    RecipeFields.image: image != null ? Base64Encoder().convert(image!) : "",
    RecipeFields.preparationTime: preparationTime,
    RecipeFields.cookingTime: cookingTime,
    RecipeFields.recipeBookID: recipeBookID,
  };
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