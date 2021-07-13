
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe_model.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;

  RecipeDetail({Key? key, required this.recipe}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeDetailState();

}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: _buildBody()
    );
  }

  Widget _buildBody() {
    return ListView(
        children: [
          Image.network("https://picsum.photos/400"),
          Text(
            widget.recipe.name,
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
            itemCount: widget.recipe.ingredients.length,
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
          Text(widget.recipe.ingredients[index].name),
          Text(widget.recipe.ingredients[index].unitAmount.toString()),
        ],
      ),
    );
  }
}