import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/utilities/persistence.dart';
import 'package:recipe_manager/views/recipe_list_page.dart';

import 'edit_recipe_book_page.dart';

class RecipeBookListPage extends StatefulWidget {
  RecipeBookListPage({Key? key}) : super(key: key);

  final String title = 'My Recipe Books';

  @override
  State<StatefulWidget> createState() => _RecipeBookListPageState();
}

class _RecipeBookListPageState extends State<RecipeBookListPage> {
  List<RecipeBook> recipeBooks = <RecipeBook>[];

  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _resetDataAlert();
            },
            icon: Icon(Icons.delete_outlined),
            color: Colors.white,
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _pushEditRecipeBookPage();
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _buildBody() {
    if (recipeBooks.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return PageView.builder(
        itemCount: recipeBooks.length,
        controller: PageController(viewportFraction: 0.55),
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeBookColumn(index);
        });
  }

  Widget _buildRecipeBookColumn(int index) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 180, child: _buildRecipeBookImage(index)),
          Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text(recipeBooks[index].name, style: TextStyle(fontSize: 18)))
        ],
      ),
      onTap: () {
        _pushRecipeListPage(index);
      },
      onLongPress: () {
        _pushEditRecipeBookPage(recipeBook: recipeBooks[index]);
      },
    );
  }

  Widget _buildRecipeBookImage(int index) {
    return FutureBuilder(
      future: recipeBooks[index].image,
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final _recipeBook = recipeBooks[index];
      return RecipeListPage(recipeBook: _recipeBook);
    }));
  }

  /// Pushes the page that allows adding or editing a recipe book
  void _pushEditRecipeBookPage({RecipeBook? recipeBook}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EditRecipeBookPage(recipeBook: recipeBook,);
    })).then((_) {
      _refreshData();
    });
  }

  /// Refreshes Data from DB and updates UI
  void _refreshData() {
    PersistenceService.instance.readAllRecipeBooks().then((recipeBooks) {
      setState(() {
        this.recipeBooks = <RecipeBook>[];
        recipeBooks.forEach((element) {
          this.recipeBooks.add(element);
        });
      });
    });
  }

  void _resetDataAlert() {
    Widget cancelButton = Center(
        child: OutlinedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));
    Widget resetDemoDataButton = Center(
      child: TextButton(
        child: Text("Reset Demo Recipes"),
        onPressed: () {
          PersistenceService.instance.resetDemoData().then((_) {
            _refreshData();
            Navigator.of(context).pop();
          });
        },
      )
    );
    Widget deleteDataButton = Center(
        child: TextButton(
      child: Text("Delete all Data"),
      onPressed: () {
        PersistenceService.instance.deleteAllData().then((_) {
          _refreshData();
          Navigator.of(context).pop();
        });
      },
    ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Data"),
      content:
          Text("Do you want to reset the demo recipes or delete all data?\nAll your recipes will be deleted!"),
      actions: [resetDemoDataButton, deleteDataButton, cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
