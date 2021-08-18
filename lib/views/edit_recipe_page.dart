import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_manager/models/recipe_detail_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';

class EditRecipePage extends StatefulWidget {
  EditRecipePage({required this.recipe});

  final Recipe recipe;
  int page = 0;

  @override
  State<StatefulWidget> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recipe.name.isNotEmpty ? widget.recipe.name : "New Recipe"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.page == 2) {
            _submitRecipe();
          } else {
            _pageController.animateToPage(widget.page + 1,
                curve: Curves.easeInOut, duration: Duration(milliseconds: 350));
          }
        },
        label: widget.page == 2 ? Text("Save") : Text('Next'),
        icon: widget.page == 2 ? Icon(Icons.save_alt) : null,
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: _pageController,
      children: [
        _buildMetaDataPage(),
        _buildIngredientsPage(),
        _buildPreparationStepsPage()
      ],
      onPageChanged: (page) {
        setState(() {
          widget.page = page;
        });
      },
    );
  }

  /// Validates input and returns the recipe to the parent view
  void _submitRecipe() {
    // TODO validate forms and save new recipe to recipe book

    // Dismiss Page and return recipeBook
    Navigator.of(context).pop(widget.recipe);
  }

  /// First page that allows user to enter meta data for the recipe
  Widget _buildMetaDataPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  FormBuilderFilterChip(
                    name: 'recipe_types',
                    decoration: InputDecoration(
                      labelText: 'Select categories',
                    ),
                    options: List<FormBuilderFieldOption>.generate(
                        RecipeType.values.length,
                        (index) => FormBuilderFieldOption(
                            value: RecipeType.values[index],
                            child: Text(RecipeType.values[index].name()))),
                    spacing: 8,
                  ),
                  FormBuilderField(
                    name: 'images',
                    builder: (FormFieldState<dynamic> field) {
                      return InputDecorator(
                        decoration: InputDecoration(labelText: 'Select images'),
                        child: Container(
                          height: 100,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == widget.recipe.images.length) {
                                    _getImage();
                                  } else {
                                    _removeImage(index);
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.black12,
                                  child: index == widget.recipe.images.length
                                      ? Icon(Icons.add)
                                      : Image.memory(widget.recipe.images[index]),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width: 12,
                            ),
                            itemCount: widget.recipe.images.length + 1,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Second page that allows user to enter all ingredients for the recipe
  Widget _buildIngredientsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [Text("Ingredients")],
      ),
    );
  }

  /// Third page that allows user to enter all preparation steps for the recipe
  Widget _buildPreparationStepsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [Text("Preparation steps")],
      ),
    );
  }

  /// Launches an image picker and lets the user select an image from the gallery
  Future _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      var imageData = await image.readAsBytes();
      setState(() {
        widget.recipe.images.add(imageData);
      });
    }
  }

  /// Prompts user to confirm the removal of an image
  _removeImage(int index) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed:  () {
        Navigator.of(context).pop();
        setState(() {
          widget.recipe.images.removeAt(index);
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove image?"),
      content: Text("Would you like to remove this image?"),
      actions: [
        cancelButton,
        continueButton,
      ],
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
