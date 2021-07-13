import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/views/recipe_list_view.dart';

class RecipeBookList extends StatefulWidget {
  RecipeBookList({Key? key, required this.title, required this.recipeBooks}) : super(key: key);

  final String title;
  final List<RecipeBook> recipeBooks;// = <RecipeBook>[];

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
    return PageView.builder(
        itemCount: widget.recipeBooks.length,
        controller: PageController(viewportFraction: 0.55),
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeBookColumn(index);
        }

    );
  }

  Widget _buildRecipeBookColumn(int index) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 180,
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(widget.recipeBooks[index].name)
          )
        ],
      ),
      onTap: () {
        _pushRecipeListPage(index);
      },
    );
  }

  /// Pushes the page that displays the content of the recipe book
  void _pushRecipeListPage(int index) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          final _recipeBook = widget.recipeBooks[index];
          return RecipeList(recipeBook: _recipeBook);
        })
    );
  }
}
