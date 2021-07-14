

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/image_utils.dart';

class RecipeBook {
  String name;
  late Future<ByteData?> image;
  List<Recipe> recipes = <Recipe>[];

  RecipeBook(this.name, RecipeBookColor color, RecipeBookIcon icon) {
    this.image = createRecipeBookImage(color, icon);
  }
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