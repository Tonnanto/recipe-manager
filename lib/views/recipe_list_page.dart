

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/views/edit_recipe_page.dart';
import 'package:recipe_manager/views/recipe_detail_page.dart';

class RecipeListPage extends StatefulWidget {
  final RecipeBook recipeBook;

  RecipeListPage({Key? key, required this.recipeBook}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeBook.name),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _pushAddRecipePage();
          },
          child: const Icon(Icons.add)
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
          return RecipeDetailPage(recipe: _recipe);
        })
    );
  }

  void _pushAddRecipePage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return EditRecipePage();
        })
    ).then((editedRecipe) {
      // New RecipeBook has been created
      setState(() {
        if (editedRecipe != null)
          widget.recipeBook.recipes.add(editedRecipe);
      });
    });
  }
}