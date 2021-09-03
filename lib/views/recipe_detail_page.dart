import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';
import 'package:recipe_manager/utilities/persistence.dart';
import 'package:recipe_manager/views/edit_recipe_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Recipe? recipe;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshRecipe();
  }

  /// Refreshes Data from DB and updates UI
  Future refreshRecipe() async {
    setState(() => isLoading = true);

    this.recipe = await DataService.instance.readRecipe(widget.recipeId);
    await this.recipe?.loadIngredients();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe?.name ?? ''),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                if (recipe != null) {
                  _pushEditRecipePage(recipe!);
                }
              },
            )
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBody());
  }

  Widget _buildBody() {
    return ListView(
      children: [
        if (recipe!.image != null)
          AspectRatio(
            aspectRatio: 1.0,
            child: FittedBox(
              child: Image.memory(recipe!.image!),
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            recipe!.name,
            style: TextStyle(fontSize: 32),
          ),
        ),
        _buildMetaDataList(),
        _buildIngredientList(),
        _buildPreparationStepList(),
        SizedBox(
          height: 64,
        )
      ],
    );
  }

  Widget _buildMetaDataList() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12.0,
            children: [
              _buildTimeChip('Prep Time', (recipe?.preparationTime.toString() ?? '') + ' min'),
              if ((recipe?.cookingTime ?? 0) > 0)
                _buildTimeChip('Cook Time', (recipe?.cookingTime.toString() ?? '') + ' min'),
            ]
          ),
          SizedBox(height: 12,),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12.0,
            children:
                List.generate(recipe?.recipeTypes.length ?? 0, (int index) {
              return Chip(
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(recipe!.recipeTypes[index].name()),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String title, String value) {
    return Container(
      width: 130,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Colors.black12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.timer),
          Column(
            children: [
              Text(title),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ]
          ),
          Container(),
        ],
      ),
    );
  }

  Widget _buildIngredientList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Ingredients",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 16,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _buildIngredientRow(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: recipe!.ingredients.length,
            ))
      ]),
    );
  }

  Widget _buildIngredientRow(int index) {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(recipe!.ingredients[index].name),
          Text(recipe!.ingredients[index].unitAmount.toString()),
        ],
      ),
    );
  }

  Widget _buildPreparationStepList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Preparation Steps",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 16,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildPreparationStepRow(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: recipe!.preparationSteps.length,
          ),
        ),
      ]),
    );
  }

  Widget _buildPreparationStepRow(int index) {
    return ConstrainedBox(
      constraints: BoxConstraints(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(child: Text((index + 1).toString())),
            ),
          ),
          Text(
            recipe!.preparationSteps[index],
            maxLines: 80,
          ),
        ],
      ),
    );
  }

  /// Pushes the page that allows editing a recipe
  void _pushEditRecipePage(Recipe recipe) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EditRecipePage(
        recipe: recipe,
        recipeBookID: recipe.recipeBookID,
      );
    })).then((_) {
      refreshRecipe();
    });
  }
}
