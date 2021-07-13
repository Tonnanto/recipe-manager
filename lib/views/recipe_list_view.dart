

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/views/recipe_detail_view.dart';

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
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeRow(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
        itemCount: widget.recipeBook.recipes.length,
        padding: EdgeInsets.all(16),
    );
  }

  Widget _buildRecipeRow(int index) {
    return ListTile(
      leading: Image.network("https://picsum.photos/300"),
      title: Text(widget.recipeBook.recipes[index].name),
      onTap: () {
        _pushRecipeDetailPage(index);
      },
    );
  }

  void _pushRecipeDetailPage(int index) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          final _recipe = widget.recipeBook.recipes[index];
          return RecipeDetail(recipe: _recipe);
        })
    );
  }
}