
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/persistence.dart';
import 'package:recipe_manager/views/edit_recipe_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeDetailPageState();

}

class _RecipeDetailPageState extends State<RecipeDetailPage> {

  late Recipe recipe;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshRecipe();
  }

  /// Refreshes Data from DB and updates UI
  Future refreshRecipe() async {
    setState(() => isLoading = true);

    this.recipe = await PersistenceService.instance.readRecipe(widget.recipeId);
    await this.recipe.loadIngredients();

    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                _pushEditRecipePage(recipe);
              },
            )
          ],
        ),
        body:  isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBody()
    );
  }

  Widget _buildBody() {
    return ListView(
        children: [
          // TODO: Add Default Recipe Image
          (recipe.image != null) ? Image.memory(recipe.image!) : Image.network("https://picsum.photos/400"),
          Text(
            recipe.name,
            style: TextStyle(fontSize: 32),
          ),
          _buildIngredientList()
        ],
      );
  }

  Widget _buildIngredientList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ingredients",
          style: TextStyle(fontSize: 18),
        ),
        Container(
          height: 800,
          padding: EdgeInsets.all(16),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildIngredientRow(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: recipe.ingredients.length,
          )
        )
      ]
    );
  }

  Widget _buildIngredientRow(int index) {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(recipe.ingredients[index].name),
          Text(recipe.ingredients[index].unitAmount.toString()),
        ],
      ),
    );
  }

  /// Pushes the page that allows editing a recipe
  void _pushEditRecipePage(Recipe recipe) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EditRecipePage(recipe: recipe, recipeBookID: recipe.recipeBookID,);
    })).then((_) {
      refreshRecipe();
    });
  }
}