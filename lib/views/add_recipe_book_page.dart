
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/utilities/image_utils.dart';

class AddRecipeBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddRecipeBookPageState();

  String _name = "";
  ByteData? image;
  RecipeBookColor color = RecipeBookColor.values.first; // TODO: randomize
  RecipeBookIcon glyph = RecipeBookIcon.values.first; // TODO: randomize
}

class _AddRecipeBookPageState extends State<AddRecipeBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._name.isNotEmpty ? widget._name : "New Recipe Book"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _submitRecipeBook();
          },
          label: Text("Save"),
          icon: Icon(Icons.save_alt),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        Container(
          height: 200,
          margin: EdgeInsets.all(32),
          child: FutureBuilder(
            future: createRecipeBookImage(widget.color, widget.glyph),
            builder: (BuildContext context, AsyncSnapshot<ByteData?> snapshot) {

              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                widget.image = snapshot.data!;
                return Image.memory(Uint8List.view(snapshot.data!.buffer));

              } else if (widget.image != null) {
                return Image.memory(Uint8List.view(widget.image!.buffer));

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
          margin: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onChanged: (String input) {
                setState(() {
                  widget._name = input;
                });
              },
            ),
          ),
        ),
        _buildColorPicker(),
        _buildGlyphPicker(),
        SizedBox(height: 80)
      ]
    );
  }

  Container _buildColorPicker() {
    return Container(
      height: 100,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Color",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 64,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _buildColorItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 16,);
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
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Icon",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 64,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return _buildGlyphItem(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 16,);
                },
                itemCount: RecipeBookIcon.values.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        )
      );
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
          widget.color = RecipeBookColor.values[index];
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
          widget.glyph = RecipeBookIcon.values[index];
        });
      },
    );
  }

  void _submitRecipeBook() {
    // Validate Input
    if (_formKey.currentState?.validate() ?? false) {

      // Create RecipeBook
      RecipeBook recipeBook = RecipeBook(widget._name, widget.color, widget.glyph);

      // Dismiss Page and return recipeBook
      Navigator.of(context).pop(recipeBook);
    }
  }
}



