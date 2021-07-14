

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';


/// Loads an image from assets
Future<ui.Image> loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final list = Uint8List.view(data.buffer);
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(list, completer.complete);
  return completer.future;
}

/// Creates the image of a recipe book. Individual book color and individual glyph
Future<ByteData?> createRecipeBookImage(RecipeBookColor color, RecipeBookIcon glyph) async {
  ui.PictureRecorder recorder = new ui.PictureRecorder();
  Canvas canvas = new Canvas(recorder);

  ui.Image bookImage = await loadUiImage('assets/images/recipe_books/recipeBook_${color.toString().split('.').last}.png');
  ui.Image glyphImage = await loadUiImage(glyph.imagePath());

  canvas.drawImage(bookImage, Offset.zero, Paint());
  canvas.drawImage(glyphImage, Offset(bookImage.width * 0.57 - glyphImage.width * 0.5, bookImage.height * 0.3 - glyphImage.height * 0.5), Paint());

  ui.Picture p = recorder.endRecording();
  ui.Image image = await p.toImage(bookImage.width, bookImage.height);
  return image.toByteData(format: ui.ImageByteFormat.png);
}