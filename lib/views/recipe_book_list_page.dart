import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshRecipeBooks();
  }

  /// Refreshes Data from DB and updates UI
  Future _refreshRecipeBooks() async {
    setState(() => isLoading = true);
    this.recipeBooks = await DataService.instance.readAllRecipeBooks();
    setState(() => isLoading = false);
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
            icon: Icon(Icons.settings_backup_restore),
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return PageView.builder(
        itemCount: recipeBooks.length,
        controller: PageController(viewportFraction: 250 / (MediaQuery.of(context).size.width)),
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
      return EditRecipeBookPage(
        recipeBook: recipeBook,
      );
    })).then((_) {
      _refreshRecipeBooks();
    });
  }

  /// Displays an Alert that allows the user to reset the demo data or to delete all data
  void _resetDataAlert() {
    Widget cancelButton = Center(
        child: Container(
      width: 220,
      child: OutlinedButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ));
    Widget resetDemoDataButton = Center(
        child: Container(
      width: 220,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        icon: Icon(Icons.restore),
        label: Text("Reset Demo Recipes"),
        onPressed: () {
          DataService.instance.resetDemoData().then((_) {
            _refreshRecipeBooks();
            Navigator.of(context).pop();
          });
        },
      ),
    ));
    Widget deleteDataButton = Center(
        child: Container(
      width: 220,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        icon: Icon(Icons.delete_outline),
        label: Text("Delete all Data"),
        onPressed: () {
          DataService.instance.deleteAllData().then((_) {
            _refreshRecipeBooks();
            Navigator.of(context).pop();
          });
        },
      ),
    ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Data"),
      content: Text(
          "Do you want to reset the demo recipes or delete all data?\nAll your recipes will be deleted!"),
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
