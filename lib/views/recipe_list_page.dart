

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
  void initState() {
    _refreshData();
    super.initState();
  }

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
    var image = widget.recipeBook.recipes[index].image;
    return ListTile(
      leading: AspectRatio(
        aspectRatio: 1.0,
        child: FittedBox(
          // TODO: Add Default Recipe Image
          child: image != null ? Image.memory(image) : Image.network("https://picsum.photos/300"),
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
      ),
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
          return RecipeDetailPage(recipeId: _recipe.id!);
        })
    ).then((value) => _refreshData());
  }

  /// Pushes the page that allows adding a recipe
  void _pushAddRecipePage({Recipe? recipe}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EditRecipePage(recipe: recipe, recipeBookID: widget.recipeBook.id!,);
    })).then((_) {
      _refreshData();
    });
  }

  /// Refreshes Data from DB and updates UI
  void _refreshData() {
    widget.recipeBook.loadRecipes().then((recipes) {
      setState(() {});
    });
  }
}
