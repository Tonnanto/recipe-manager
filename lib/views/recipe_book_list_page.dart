import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/views/recipe_list_page.dart';

import 'add_recipe_book_page.dart';

class RecipeBookListPage extends StatefulWidget {
  RecipeBookListPage({Key? key, required this.title, required this.recipeBooks}) : super(key: key);

  final String title;
  final List<RecipeBook> recipeBooks;// = <RecipeBook>[];

  @override
  State<StatefulWidget> createState() => _RecipeBookListPageState();
}

class _RecipeBookListPageState extends State<RecipeBookListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pushAddRecipeBookPage();
        },
        child: const Icon(Icons.add)
      ),
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
          SizedBox(
            width: 180,
            child: _buildRecipeBookImage(index)
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.recipeBooks[index].name,
                style: TextStyle(fontSize: 18)
              )
          )
        ],
      ),
      onTap: () {
        _pushRecipeListPage(index);
      },
    );
  }

  Widget _buildRecipeBookImage(int index) {
    return FutureBuilder(
      future: widget.recipeBooks[index].image,
      builder: (BuildContext context, AsyncSnapshot<ByteData?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(Uint8List.view(snapshot.data!.buffer));
        } else {
          // Recipe Book image not created yet -> display placeholder
          return SizedBox(
            height: 200,
            width: 160,
          );
        }
      },
    );
  }

  /// Pushes the page that displays the content of the recipe book
  void _pushRecipeListPage(int index) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          final _recipeBook = widget.recipeBooks[index];
          return RecipeListPage(recipeBook: _recipeBook);
        })
    );
  }

  /// Pushes the page that allows adding a new recipe book
  void _pushAddRecipeBookPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return AddRecipeBookPage();
        })
    ).then((newRecipeBook) {
      // New RecipeBook has been created
      setState(() {
        if (newRecipeBook != null)
          widget.recipeBooks.add(newRecipeBook);
      });
    });
  }
}
