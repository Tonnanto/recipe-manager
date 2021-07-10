

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';

class RecipeList extends StatefulWidget {
  final RecipeBook recipeBook;

  RecipeList({Key? key, required this.recipeBook}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeBook.name),
      ),
      body: Center(
          child: Image.network("https://picsum.photos/200/300")
      ),
    );
  }

}