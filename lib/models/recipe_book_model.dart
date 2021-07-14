

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/image_utils.dart';

class RecipeBook {
  String name;
  late Future<ByteData?> image;
  List<Recipe> recipes = <Recipe>[];

  RecipeBook(this.name, RecipeBookColor color, RecipeBookIcon icon) {
    this.image = _createImage(color, icon);

  }

  Future<ByteData?> _createImage(RecipeBookColor color, RecipeBookIcon glyph) async {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    ui.Image bookImage = await loadUiImage('assets/images/recipe_books/recipeBook_${color.toString().split('.').last}.png');
    ui.Image glyphImage = await loadUiImage('assets/images/recipe_book_glyphs/${glyph.toString().split('.').last}.png');

    canvas.drawImage(bookImage, Offset.zero, Paint());
    canvas.drawImage(glyphImage, Offset(bookImage.width * 0.57 - glyphImage.width * 0.5, bookImage.height * 0.3 - glyphImage.height * 0.5), Paint());

    ui.Picture p = recorder.endRecording();
    ui.Image image = await p.toImage(bookImage.width, bookImage.height);
    return image.toByteData(format: ui.ImageByteFormat.png);
  }
}

enum RecipeBookColor {
  salmon, cantaloupe, banana, honeydew, flora, spindrift, ice, sky, orchid, lavender, bubblegum, carnation
}

enum RecipeBookIcon {
  cooking_hat, dishes, ingredients, man, pan
}