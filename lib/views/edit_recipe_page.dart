
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:recipe_manager/models/recipe_model.dart';

class EditRecipePage extends StatefulWidget {

  EditRecipePage({
    required this.recipe
  });

  final Recipe recipe;

  @override
  State<StatefulWidget> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name.isNotEmpty ? widget.recipe.name : "New Recipe"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _submitRecipe();
        },
        label: Text("Save"),
        icon: Icon(Icons.save_alt),
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      children: [
        _buildMetaDataPage(),
        _buildIngredientsPage(),
        _buildPreparationStepsPage()
      ],
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
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                
              ],
            )
          )
        ],
      ),
    );
  }

  /// Second page that allows user to enter all ingredients for the recipe
  Widget _buildIngredientsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Ingredients")
        ],
      ),
    );
  }

  /// Third page that allows user to enter all preparation steps for the recipe
  Widget _buildPreparationStepsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Preparation steps")
        ],
      ),
    );
  }


}