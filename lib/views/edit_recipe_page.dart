import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_manager/models/recipe_detail_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';

class EditRecipePage extends StatefulWidget {
  EditRecipePage();

  Recipe? recipe;
  int page = 0;

  @override
  State<StatefulWidget> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _ingredientsFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _preparationStepsFormKey = GlobalKey<FormBuilderState>();
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // TODO: Use name from FormBuilder values
          //   widget.recipe.name.isNotEmpty ? widget.recipe.name :
            "New Recipe"),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
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
                  // FormBuilderField(
                  //   name: 'image',
                  //   builder: (FormFieldState<dynamic> field) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(labelText: 'Select image'),
                  //       child: Container(
                  //         height: 100,
                  //         child: ListView.separated(
                  //           itemBuilder: (context, index) {
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 // TODO: Get image data from FormBuilder values
                  //                 if (widget.recipe.image == null) {
                  //                   _getImage();
                  //                 } else {
                  //                   _removeImage();
                  //                 }
                  //               },
                  //               child: Container(
                  //                 height: 100,
                  //                 width: 100,
                  //                 color: Colors.black12,
                  //                 child: index == widget.recipe.image.length
                  //                     ? Icon(Icons.add)
                  //                     : Image.memory(
                  //                         widget.recipe.image),
                  //               ),
                  //             );
                  //           },
                  //           separatorBuilder: (context, index) => SizedBox(
                  //             width: 12,
                  //           ),
                  //           itemCount: 1,
                  //           scrollDirection: Axis.horizontal,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  FormBuilderTextField(
                    name: 'prep_time',
                    decoration: InputDecoration(
                      labelText: 'Preparation Time (min)',
                    ),
                    valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                  FormBuilderTextField(
                    name: 'cook_time',
                    decoration: InputDecoration(
                      labelText: 'Cooking Time (min)',
                    ),
                    valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(context),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 120,
                  )
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
        // Expanded(
          // child: FormBuilder(
          //   key: _preparationStepsFormKey,
          //   child: ListView.separated(
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       if (index == widget.recipe.preparationSteps.length) {
          //         return Container(
          //             height: 50,
          //             child: Center(
          //               child: ElevatedButton.icon(
          //                 onPressed: () {
          //                   setState(() {
          //                     widget.recipe.preparationSteps
          //                         .add('');
          //                   });
          //                 },
          //                 label: Text('Add Preparation Step'),
          //                 icon: Icon(Icons.add),
          //               ),
          //             ));
          //       }
          //       return Container(
          //         padding: EdgeInsets.symmetric(horizontal: 16),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Container(
          //                 width: 32.0,
          //                 height: 32.0,
          //                 decoration: new BoxDecoration(
          //                   color: Theme.of(context).primaryColor,
          //                   shape: BoxShape.circle,
          //                 ),
          //                 child: Center(
          //                     child: Text((index + 1).toString())
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Flexible(
          //                   flex: 8,
          //                   child: ConstrainedBox(
          //                     constraints: BoxConstraints(
          //                       maxHeight: 300
          //                     ),
          //                     child: FormBuilderTextField(
          //                       name: 'prep_step $index',
          //                       decoration: InputDecoration(
          //                         hintText: 'Step ' + (index + 1).toString() + '...',
          //                       ),
          //                       initialValue: widget.recipe.preparationSteps[index],
          //                       keyboardType: TextInputType.multiline,
          //                       minLines: 1,
          //                       maxLines: 36,
          //                     ),
          //                   ),
          //                 ),
          //                 Flexible(
          //                   child: IconButton(
          //                     icon: Icon(Icons.remove_circle),
          //                     color: Colors.black26,
          //                     onPressed: () {
          //                       _removePrepStep(index);
          //                     },
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //     separatorBuilder: (context, index) => SizedBox(
          //       height: 8,
          //     ),
          //     itemCount: widget.recipe.preparationSteps.length + 1,
          //     padding: EdgeInsets.only(bottom: 100),
          //   ),
          // ),
        // ),
      ],
    );
  }

  /// Launches an image picker and lets the user select an image from the gallery
  Future _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      var imageData = await image.readAsBytes();
      setState(() {
        // TODO: Store imageData in FormBuilder value
        // widget.recipe.image = imageData;
      });
    }
  }

  /// Prompts user to confirm the removal of the image
  _removeImage() {
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
          // TODO: Remove image from FormBuilder data
          // widget.recipe.image = null;
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
  void _removePrepStep(int index) {
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
          // TODO: Remove Prep Step at appropriate place
          // widget.recipe.preparationSteps.removeAt(index);
        });
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
}
