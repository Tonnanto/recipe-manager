

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatefulWidget {
  final String recipeBookName;

  RecipeList({Key? key, required this.recipeBookName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeBookName),
      ),
      body: Center(
          child: Image.network("https://picsum.photos/200/300")
      ),
    );
  }

}