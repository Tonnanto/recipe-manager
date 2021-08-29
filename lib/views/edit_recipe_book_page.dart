import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/utilities/image_utils.dart';
import 'package:recipe_manager/utilities/persistence.dart';

class EditRecipeBookPage extends StatefulWidget {
  final RecipeBook? recipeBook;

  const EditRecipeBookPage({
    Key? key,
    this.recipeBook,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditRecipeBookPageState();
}

class _EditRecipeBookPageState extends State<EditRecipeBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String name;
  late RecipeBookColor color;
  late RecipeBookIcon glyph;

  Uint8List? image;

  @override
  void initState() {
    super.initState();

    name = widget.recipeBook?.name ?? "";
    color = widget.recipeBook?.color ??
        RecipeBookColor.values.first; // TODO: randomize
    glyph = widget.recipeBook?.icon ??
        RecipeBookIcon.values.first; // TODO: randomize
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name.isNotEmpty ? name : "New Recipe Book"),
        actions: [
          // Only display delete button if in editing mode
          widget.recipeBook != null ?
          IconButton(
            onPressed: () {
              _deleteRecipeBookAlert();
            },
            icon: Icon(Icons.delete),
            color: Colors.white,
          ) :
          Container()
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addOrUpdateRecipeBook();
        },
        label: Text("Save"),
        icon: Icon(Icons.save_alt),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(children: [
      Container(
        height: 200,
        margin: EdgeInsets.all(32),
        child: FutureBuilder(
          future: createRecipeBookImage(color, glyph),
          builder: (BuildContext context, AsyncSnapshot<ByteData?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              image = Uint8List.view(snapshot.data!.buffer);
              return Image.memory(image!);
            } else if (image != null) {
              return Image.memory(image!);
            } else {
              return SizedBox(
                height: 200,
                width: 180,
              );
            }
          },
        ),
      ),
      Container(
        height: 64,
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
            initialValue: name,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (String input) {
              setState(() {
                name = input;
              });
            },
          ),
        ),
      ),
      _buildColorPicker(),
      _buildGlyphPicker(),
      SizedBox(height: 80)
    ]);
  }

  Container _buildColorPicker() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Color",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 64,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (BuildContext context, int index) {
                return _buildColorItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 16,
                );
              },
              itemCount: RecipeBookColor.values.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildGlyphPicker() {
    return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Icon",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 64,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (BuildContext context, int index) {
                  return _buildGlyphItem(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 16,
                  );
                },
                itemCount: RecipeBookIcon.values.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ));
  }

  Widget _buildColorItem(int index) {
    return GestureDetector(
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: RecipeBookColor.values[index].color(),
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Color(0xff555555)),
        ),
      ),
      onTap: () {
        setState(() {
          color = RecipeBookColor.values[index];
        });
      },
    );
  }

  Widget _buildGlyphItem(int index) {
    return GestureDetector(
      child: Container(
        height: 56,
        width: 56,
        child: Image.asset(RecipeBookIcon.values[index].imagePath()),
      ),
      onTap: () {
        setState(() {
          glyph = RecipeBookIcon.values[index];
        });
      },
    );
  }

  void addOrUpdateRecipeBook() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.recipeBook != null;

      if (isUpdating) {
        await updateRecipeBook();
      } else {
        await addRecipeBook();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateRecipeBook() async {
    final recipeBook = widget.recipeBook!.copy(
      name: name,
      color: color,
      icon: glyph,
    );

    await PersistenceService.instance.updateRecipeBook(recipeBook);
  }

  Future addRecipeBook() async {
    final recipeBook = RecipeBook(
      name: name,
      color: color,
      icon: glyph,
    );

    await PersistenceService.instance.createRecipeBook(recipeBook);
  }

  void _deleteRecipeBookAlert() {
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
    Widget deleteButton = Center(
        child: Container(
          width: 220,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            icon: Icon(Icons.delete_outline),
            label: Text("Delete"),
            onPressed: () {
              PersistenceService.instance.deleteRecipeBook(widget.recipeBook?.id ?? 0).then((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            },
          ),
        ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Recipe Book?"),
      content:
      Text("Do you really want to delete this recipe book? This will also delete all of it's recipes!"),
      actions: [deleteButton, cancelButton],
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
