import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';
import 'package:recipe_manager/views/widgets/keep_alive_page.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final String recipeBookID;

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

  PageController _pageController = PageController(initialPage: 0, keepPage: true);
  int page = 0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        floatingActionButton: _buildActionButton()
      ),
    );
  }

  /// Implements custom behaviour on pop (Back Button)
  Future<bool> _onWillPop() async {
    if (page > 0) {
      _pageController.animateToPage(page - 1,
          curve: Curves.easeInOut, duration: Duration(milliseconds: 350));
      return false;
    }
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('This will revert all the edits you made.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  /// Action button that changes appearance and behaviour depending on the current page
  Widget _buildActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _formKey.currentState?.save();
        FocusScope.of(context).unfocus();

        if (page == 2) {
          addOrUpdateRecipe();
        } else {
          _pageController.animateToPage(page + 1,
              curve: Curves.easeInOut, duration: Duration(milliseconds: 350));
        }
      },
      label: page == 2 ? Text("Save") : Text('Next'),
      icon: page == 2 ? Icon(Icons.save_alt) : null,
    );
  }

  Widget _buildBody() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: {
        'name': widget.recipe?.name ?? '',
        'image': widget.recipe?.image ?? null,
        // Initial Value for 'recipe_types' set in FormField
        'prep_time': widget.recipe?.preparationTime.toString() ?? '',
        'cook_time': widget.recipe?.cookingTime.toString() ?? '',
        'ingredients': widget.recipe?.ingredients ?? [],
        'prep_steps': PreparationStep.fromStrings(widget.recipe?.preparationSteps ?? []),
      },
      child: PageView(
        controller: _pageController,
        children: [
          KeepAlivePage(child: _buildMetaDataPage()),
          KeepAlivePage(child: _buildIngredientsPage()),
          KeepAlivePage(child: _buildPreparationStepsPage())
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
      key: PageStorageKey(PageStorage.of(context)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(labelText: "Name"),
              validator: FormBuilderValidators.required(context),
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
                FormBuilderValidators.min(context, 1),
              ]),
              onChanged: (value) => _formKey.currentState?.fields['prep_time']?.save(),
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              name: 'cook_time',
              decoration: InputDecoration(
                labelText: 'Cooking Time (min)',
              ),
              validator: FormBuilderValidators.numeric(context),
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
          child: FormBuilderField(
            name: 'ingredients',
            validator: (value) {
              if (value == null || (value as List<dynamic>).cast<Ingredient>().where((value) => value.isValid).isEmpty)
                return 'Please add at least 1 ingredient';
            },
            builder: (FormFieldState<dynamic> field) {
              return Container(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == (field.value as List).length) {
                      return Container(
                          height: 50,
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                field.setState(() {
                                  // recipeID '' -> not assigned to a recipe yet
                                  (field.value as List).add(Ingredient(name: '', unitAmount: UnitAmount(Unit.GRAM, 0), recipeID: ''));
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
                      child: Stack(
                        children: [
                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              color: Colors.black38,
                              height: 1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 8,
                                child: TextFormField(
                                  key: ObjectKey((field.value as List)[index]),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Ingredient',
                                  ),
                                  initialValue: (field.value as List).cast<Ingredient>()[index].name,
                                  onChanged: (value) {
                                    (field.value as List<dynamic>).cast<Ingredient>()[index].name = value;
                                  },
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  key: ObjectKey((field.value as List)[index]),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'amount',
                                  ),
                                  initialValue: (field.value as List).cast<Ingredient>()[index].unitAmount.amount.toString(),
                                  onChanged: (value) {
                                    (field.value as List<dynamic>).cast<Ingredient>()[index].unitAmount.amount = double.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: DropdownButton<Unit>(
                                  key: UniqueKey(),
                                  items: List<DropdownMenuItem<Unit>>.generate(
                                      Unit.values.length,
                                          (index) => DropdownMenuItem(
                                          value: Unit.values[index],
                                          child: Text(Unit.values[index].shortString()))
                                  ),
                                  underline: Container(),
                                  value: (field.value as List).cast<Ingredient>()[index].unitAmount.unit,
                                  onChanged: (value) {
                                    field.setState(() {
                                      if (value != null) {
                                        (field.value as List<dynamic>).cast<Ingredient>()[index].unitAmount.unit = value;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Flexible(
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.black26,
                                  onPressed: () {
                                    _removeIngredient().then((remove) {
                                      if (remove) {
                                        setState(() {
                                          (field.value as List<dynamic>).removeAt(index);
                                        });
                                      }
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ]
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8,
                  ),
                  itemCount: (field.value as List).length + 1,
                  padding: EdgeInsets.only(bottom: 100),
                ),
              );
            },
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
            validator: (value) {
              if (value == null || (value as List<dynamic>).cast<PreparationStep>().where((value) => value.content.isNotEmpty).isEmpty)
                return 'Please add at least 1 preparation step';
            },
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
                                (field.value as List<dynamic>).add(PreparationStep(content: ''));
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
                                child: TextFormField(
                                  key: ObjectKey((field.value as List)[index]),
                                  decoration: InputDecoration(
                                    hintText: 'Step ' + (index + 1).toString() + '...',
                                  ),
                                  initialValue: (field.value as List<dynamic>).cast<PreparationStep>()[index].content,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 36,
                                  onChanged: (value) {
                                    (field.value as List<dynamic>).cast<PreparationStep>()[index].content = value;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.black26,
                                onPressed: () {
                                  _removePrepStep().then((remove) {
                                    if (remove) {
                                      setState(() {
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
  Future<bool> _removeIngredient() async {
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
      title: Text("Remove ingredient?"),
      content: Text("Would you like to remove this ingredient?"),
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

  /// Prompts user to confirm the removal of an preparation step
  Future<bool> _removePrepStep() async {
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
      print('valid');
      final isUpdating = widget.recipe != null;

      if (isUpdating) {
        await updateRecipe();
      } else {
        await addRecipe();
      }

      Navigator.of(context).pop();

    } else {

      // Scroll to invalid page and focus invalid field
      for (MapEntry<String, FormBuilderFieldState> entry in _formKey.currentState!.fields.entries) {
        if (!entry.value.isValid) {
          int invalidPage = 0;
          if (entry.key == 'ingredients') {
            invalidPage = 1;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please add at least 1 ingredient"),
            ));
          }
          if (entry.key == 'prep_steps') {
            invalidPage = 2;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please add at least 1 preparation step"),
            ));
          }
          _pageController.animateToPage(invalidPage, curve: Curves.easeInOut, duration: Duration(milliseconds: 350));
          entry.value.requestFocus();

          break;
        }
      }
    }
  }

  /// Updates an existing recipe in the database
  Future updateRecipe() async {
    final recipe = widget.recipe!.copy(
      name: _formKey.currentState!.value['name'],
      recipeTypes: (_formKey.currentState!.value['recipe_types'] as List<dynamic>).cast<RecipeType>(),
      preparationTime: int.tryParse(_formKey.currentState!.value['prep_time']),
      cookingTime: int.tryParse(_formKey.currentState!.value['cook_time']),
      preparationSteps: PreparationStep.toStrings((_formKey.currentState!.value['prep_steps'] as List<dynamic>).cast<PreparationStep>().where((p) => p.content.isNotEmpty).toList()),
    );
    // setting image separate from copy method. because removing the existing image (setting image to null) in copy method will not work.
    recipe.image = _formKey.currentState!.value['image'];

    Iterable<Ingredient> ingredients = (_formKey.currentState!.value['ingredients'] as List<dynamic>).cast<Ingredient>().where((i) => i.name.isNotEmpty && i.unitAmount.amount > 0);
    await DataService.instance.updateRecipe(recipe);
    await recipe.updateIngredients(ingredients);
  }

  /// Adds a new recipe to the database
  Future addRecipe() async {
    final recipe = Recipe(
      name: _formKey.currentState!.value['name'],
      recipeBookID: widget.recipeBookID,
      recipeTypes: (_formKey.currentState!.value['recipe_types'] as List<dynamic>).cast<RecipeType>(),
      image: _formKey.currentState!.value['image'],
      preparationTime: int.tryParse(_formKey.currentState!.value['prep_time']) ?? 0,
      cookingTime: int.tryParse(_formKey.currentState!.value['cook_time']) ?? 0,
      preparationSteps: PreparationStep.toStrings((_formKey.currentState!.value['prep_steps'] as List<dynamic>).cast<PreparationStep>().where((p) => p.content.isNotEmpty).toList()),
    );

    List<Ingredient> ingredients = (_formKey.currentState!.value['ingredients'] as List<dynamic>).cast<Ingredient>();
    Recipe newRecipe = await DataService.instance.createRecipe(recipe);
    await newRecipe.updateIngredients(ingredients);
  }

  /// Displays an alert and deletes a recipe from the database after user confirmation
  void _deleteRecipeAlert() {
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
            style: ElevatedButton.styleFrom(
                primary: Colors.red
            ),
            icon: Icon(Icons.delete_outline),
            label: Text("Delete"),
            onPressed: () {
              if (widget.recipe != null) {
                DataService.instance.deleteRecipe(widget.recipe!).then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              }
            },
          ),
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
