import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/views/recipe_list_view.dart';

class RecipeBookList extends StatefulWidget {
  RecipeBookList({Key? key, required this.title}) : super(key: key);

  final String title;
  final Iterable<String> _recipeBooks = <String>[]; // TODO: create RecipeBook class

  @override
  State<StatefulWidget> createState() => _RecipeBookListState();
}

class _RecipeBookListState extends State<RecipeBookList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, i) {
          // Divider
          if (i.isOdd) return Divider();

          return _buildRow("Antons Recipes");
        }
    );
  }

  Widget _buildRow(String recipeBookName) {
    return ListTile(
      title: Text(recipeBookName),
      onTap: () {
        _pushRecipeBookPage(recipeBookName);
      },
    );
  }

  void _pushRecipeBookPage(String recipeBookName) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          final _recipeBookName = recipeBookName;
          return RecipeList(recipeBookName: _recipeBookName);
        })
    );
  }
}
