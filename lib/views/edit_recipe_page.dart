import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/persistence.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final int recipeBookID;

  const EditRecipePage({
    Key? key,
    this.recipe,
    required this.recipeBookID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _ingredientsFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _preparationStepsFormKey = GlobalKey<FormBuilderState>();

  PageController _pageController = PageController(initialPage: 0, keepPage: false);
  int page = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recipe == null ? 'New Recipe' : 'Edit Recipe'
        ),
        actions: [
          // Only display delete button if in editing mode
          widget.recipe != null ?
          IconButton(
            onPressed: () {
              _deleteRecipeAlert();
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
          _formKey.currentState?.save();

          if (page == 2) {
            addOrUpdateRecipe();

          } else {
            _pageController.animateToPage(page + 1,
                curve: Curves.easeInOut, duration: Duration(milliseconds: 350));
          }
        },
        label: page == 2 ? Text("Save") : Text('Next'),
        icon: page == 2 ? Icon(Icons.save_alt) : null,
      ),
    );
  }

  Widget _buildBody() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: {
        'name': widget.recipe?.name ?? '',
        'image': widget.recipe?.image ?? null,
        // Initial Value for 'recipe_types' set in FormField
        'prep_time': widget.recipe?.preparationTime.toString() ?? '',
        'cook_time': widget.recipe?.cookingTime.toString() ?? '',

        'prep_steps': widget.recipe?.preparationSteps ?? [],
      },
      child: PageView(
        controller: _pageController,
        children: [
          _buildMetaDataPage(),
          _buildIngredientsPage(),
          _buildPreparationStepsPage()
        ],
        onPageChanged: (page) {
          setState(() {
            this.page = page;
            _formKey.currentState?.save();
          });
        },
      ),
      onChanged: () => _formKey.currentState?.save(),
    );
  }

  /// First page that allows user to enter meta data for the recipe
  Widget _buildMetaDataPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(labelText: "Name"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
              onChanged: (value) => _formKey.currentState?.fields['name']?.save(),
            ),
            FormBuilderField(
              name: 'image',
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: InputDecoration(labelText: 'Select image'),
                  child: Container(
                    height: field.value == null ? 50 : 200,
                    child: GestureDetector(
                      onTap: () {
                        if (field.value == null) {
                          _getImage().then((imageData) {
                            field.didChange(imageData);
                          });
                        } else {
                          _removeImage().then((remove) {
                            if (remove) field.didChange(null);
                          });
                        }
                      },
                      child: Container(
                        child: field.value == null
                            ? Icon(Icons.add)
                            : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.memory(field.value),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            FormBuilderFilterChip(
              name: 'recipe_types',
              initialValue: widget.recipe?.recipeTypes ?? [],
              decoration: InputDecoration(
                labelText: 'Select categories',
              ),
              options: List<FormBuilderFieldOption>.generate(
                  RecipeType.values.length,
                  (index) => FormBuilderFieldOption(
                      value: RecipeType.values[index],
                      child: Text(RecipeType.values[index].name()))
              ),
              onChanged: (value) => _formKey.currentState?.fields['recipe_types']?.save(),
              spacing: 8,
            ),
            FormBuilderTextField(
              name: 'prep_time',
              decoration: InputDecoration(
                labelText: 'Preparation Time (min)',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.numeric(context),
              ]),
              onChanged: (value) => _formKey.currentState?.fields['prep_time']?.save(),
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              name: 'cook_time',
              decoration: InputDecoration(
                labelText: 'Cooking Time (min)',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.numeric(context),
              ]),
              onChanged: (value) => _formKey.currentState?.fields['cook_time']?.save(),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }

  /// Second page that allows user to enter all ingredients for the recipe
  Widget _buildIngredientsPage() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Ingredients',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        Expanded(
          child: FormBuilder(
            key: _ingredientsFormKey,
            child: ListView.separated(
              itemBuilder: (context, index) {
                // TODO: Access FormBuilder value
                if (index == (widget.recipe?.ingredients.length ?? 0)) {
                  return Container(
                      height: 50,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              // TODO: Store values in FormBuilder
                              // widget.recipe.ingredients
                              //     .add(Ingredient('', UnitAmount(Unit.GRAM, 0)));
                            });
                          },
                          label: Text('Add Ingredient'),
                          icon: Icon(Icons.add),
                        ),
                      ));
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 8,
                        child: FormBuilderTextField(
                          name: 'ingredient $index',
                          decoration: InputDecoration(
                            hintText: 'Ingredient',
                          ),
                          // TODO: Get initial value from form builder?
                          // initialValue: widget.recipe.ingredients[index].name,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: FormBuilderTextField(
                          name: 'amount',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'amount',
                          ),
                          // TODO: Get initial value from form builder?
                          // initialValue: widget
                          //     .recipe.ingredients[index].unitAmount.amount
                          //     .toString(),
                          // onChanged: (value) {
                          //   widget.recipe.ingredients[index].unitAmount.amount = _ingredientsFormKey.currentState?.value['amount'];
                          // },
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: FormBuilderDropdown(
                          // TODO: Appropriate names for FormBuilderFields
                          name: 'unit' + index.toString(),
                          items: List<DropdownMenuItem>.generate(
                              Unit.values.length,
                              (index) => DropdownMenuItem(
                                  value: Unit.values[index],
                                  child: Text(Unit.values[index].shortString()))
                          ),
                          // TODO: Get initial value from form builder?
                          // initialValue:
                          //     widget.recipe.ingredients[index].unitAmount.unit,
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.black26,
                          onPressed: () {
                            _removeIngredient(index);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 8,
              ),
              // TODO: Store Ingredients separate and adjust itemCount
              itemCount: 1,
              padding: EdgeInsets.only(bottom: 100),
            ),
          ),
        ),
      ],
    );
  }

  /// Third page that allows user to enter all preparation steps for the recipe
  Widget _buildPreparationStepsPage() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Preparation Steps',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),

        Expanded(
          child: FormBuilderField(
            name: 'prep_steps',
            builder: (FormFieldState<dynamic> field) {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == (field.value as List).length) {
                    return Container(
                        height: 50,
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              field.setState(() {
                                (field.value as List<dynamic>).add('');
                              });
                            },
                            label: Text('Add Preparation Step'),
                            icon: Icon(Icons.add),
                          ),
                        ));
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: new BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text((index + 1).toString())
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 8,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 300
                                ),
                                child: FormBuilderTextField(
                                  name: 'prep_step $index',
                                  decoration: InputDecoration(
                                    hintText: 'Step ' + (index + 1).toString() + '...',
                                  ),
                                  initialValue: field.value[index],
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 36,
                                  onChanged: (value) {
                                    (field.value as List<dynamic>)[index] = value;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.black26,
                                onPressed: () {
                                  _removePrepStep(index).then((remove) {
                                    print(remove);
                                    if (remove) {
                                      field.setState(() {
                                        (field.value as List<dynamic>).removeAt(index);
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 8,
                ),
                itemCount: (field.value as List).length + 1,
                padding: EdgeInsets.only(bottom: 100),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Launches an image picker and lets the user select an image from the gallery
  Future<Uint8List?> _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return await image.readAsBytes();
    }
  }

  /// Prompts user to confirm the removal of the image
  Future<bool> _removeImage() async {
    bool remove = false;

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed: () {
        Navigator.of(context).pop();
        remove = true;
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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return remove;
  }

  /// Prompts user to confirm the removal of an ingredient
  _removeIngredient(int index) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          // TODO: Remove ingredient at appropriate place
          // widget.recipe.ingredients.removeAt(index);
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove ingredient?"),
      content: Text("Would you like to remove this ingredient?"),
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

  /// Prompts user to confirm the removal of an preparation step
  Future<bool> _removePrepStep(int index) async {
    bool remove = false;

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed: () {
        Navigator.of(context).pop();
        remove = true;
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Step?"),
      content: Text("Would you like to remove this preparation step?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return remove;
  }

  /// validates form and adds or updates the recipe in the database
  void addOrUpdateRecipe() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final isUpdating = widget.recipe != null;

      if (isUpdating) {
        await updateRecipe();
      } else {
        await addRecipe();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateRecipe() async {
    final recipe = widget.recipe!.copy(
      name: _formKey.currentState!.value['name'],
      recipeTypes: (_formKey.currentState!.value['recipe_types'] as List<dynamic>).cast<RecipeType>(),
      image: _formKey.currentState!.value['image'],
      preparationTime: int.tryParse(_formKey.currentState!.value['prep_time']),
      cookingTime: int.tryParse(_formKey.currentState!.value['cook_time']),

      preparationSteps: (_formKey.currentState!.value['prep_steps'] as List<dynamic>).cast<String>(),
      // TODO: Ingredients
    );

    await PersistenceService.instance.updateRecipe(recipe);
  }

  Future addRecipe() async {
    final recipe = Recipe(
      name: _formKey.currentState!.value['name'],
      recipeBookID: widget.recipeBookID,
      recipeTypes: (_formKey.currentState!.value['recipe_types'] as List<dynamic>).cast<RecipeType>(),
      image: _formKey.currentState!.value['image'],
      preparationTime: int.tryParse(_formKey.currentState!.value['prep_time']) ?? 0,
      cookingTime: int.tryParse(_formKey.currentState!.value['cook_time']),

      preparationSteps: (_formKey.currentState!.value['prep_steps'] as List<dynamic>).cast<String>(),
      // TODO: Ingredients
    );

    await PersistenceService.instance.createRecipe(recipe);
  }

  void _deleteRecipeAlert() {
    Widget cancelButton = Center(
        child: OutlinedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
    Widget deleteButton = Center(
        child: TextButton(
          child: Text("Delete"),
          onPressed: () {
            PersistenceService.instance.deleteRecipe(widget.recipe?.id ?? 0).then((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          },
        )
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Recipe?"),
      content:
      Text("Do you really want to delete this recipe?"),
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
