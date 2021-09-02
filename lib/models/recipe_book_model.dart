

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';
import 'package:recipe_manager/utilities/image_utils.dart';

final String tableRecipeBooks = 'recipe_books';

class RecipeBook {
  final int? id;
  final String name;

  final RecipeBookColor color;
  final RecipeBookIcon icon;

  List<Recipe> recipes = <Recipe>[];
  late Future<ByteData?> image;

  RecipeBook({
    this.id,
    required this.name,
    required this.color,
    required this.icon
  }) {
    image = createRecipeBookImage(color, icon);
  }

  /// Updates the recipes field with data from the database
  Future<List<Recipe>> loadRecipes() async {
    if (this.id != null) {
      this.recipes = await DataService.instance.readRecipesFromBook(this.id!);
    }
    return recipes;
  }

  static RecipeBook fromMap(Map<String, Object?> map) => RecipeBook(
    id: map[RecipeBookFields.id] as int?,
    name: map[RecipeBookFields.name] as String,
    color: EnumToString.fromString(RecipeBookColor.values, map[RecipeBookFields.color] as String) ?? RecipeBookColor.flora,
    icon: EnumToString.fromString(RecipeBookIcon.values, map[RecipeBookFields.icon] as String) ?? RecipeBookIcon.ingredients,
  );

  Map<String, Object?> toMap() => {
    RecipeBookFields.id: id,
    RecipeBookFields.name: name,
    RecipeBookFields.color: EnumToString.convertToString(color),
    RecipeBookFields.icon: EnumToString.convertToString(icon),
  };

  /// Returns a copy of the same RecipeBook with the given fields changed
  RecipeBook copy({
    int? id,
    String? name,
    RecipeBookColor? color,
    RecipeBookIcon? icon,
  }) {
    RecipeBook copy = RecipeBook(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
    copy.recipes = this.recipes;
    return copy;
  }
}

class RecipeBookFields {
  static final List<String> values = [
    id, name, recipes
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String recipes = 'recipes';
  static final String color = 'color';
  static final String icon = 'icon';
}

enum RecipeBookColor {
  salmon, cantaloupe, banana, honeydew, flora, spindrift, ice, sky, orchid, lavender, bubblegum, carnation
}

extension RecipeBookColorExtension on RecipeBookColor {
  Color color() {
    switch (this) {
      case RecipeBookColor.salmon:
        return Color.fromRGBO(255, 126, 121, 1);
      case RecipeBookColor.cantaloupe:
        return Color.fromRGBO(255, 212, 121, 1);
      case RecipeBookColor.banana:
        return Color.fromRGBO(255, 252, 121, 1);
      case RecipeBookColor.honeydew:
        return Color.fromRGBO(212, 251, 121, 1);
      case RecipeBookColor.flora:
        return Color.fromRGBO(115, 250, 121, 1);
      case RecipeBookColor.spindrift:
        return Color.fromRGBO(115, 252, 214, 1);
      case RecipeBookColor.ice:
        return Color.fromRGBO(115, 253, 255, 1);
      case RecipeBookColor.sky:
        return Color.fromRGBO(118, 214, 255, 1);
      case RecipeBookColor.orchid:
        return Color.fromRGBO(122, 129, 255, 1);
      case RecipeBookColor.lavender:
        return Color.fromRGBO(215, 131, 255, 1);
      case RecipeBookColor.bubblegum:
        return Color.fromRGBO(255, 133, 255, 1);
      case RecipeBookColor.carnation:
        return Color.fromRGBO(255, 138, 216, 1);
    }
  }
}

enum RecipeBookIcon {
  cooking_hat, dishes, ingredients, man, pan
}

extension RecipeBookIconExtension on RecipeBookIcon {
  String imagePath() {
    return "assets/images/recipe_book_glyphs/${this.toString().split('.').last}.png";
  }
}