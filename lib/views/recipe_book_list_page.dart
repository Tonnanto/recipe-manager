import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_detail_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/views/recipe_list_page.dart';

import 'add_recipe_book_page.dart';

class RecipeBookListPage extends StatefulWidget {
  RecipeBookListPage({Key? key}) : super(key: key);

  final String title = 'My Recipe Books';
  final List<RecipeBook> recipeBooks = <RecipeBook>[];

  @override
  State<StatefulWidget> createState() => _RecipeBookListPageState();
}

class _RecipeBookListPageState extends State<RecipeBookListPage> {
  @override
  void initState() {
    // Initializing DEMO Recipes
    // TODO: Read RecipeBooks from DB
    _getDemoRecipeBooks().then((value) {
      setState(() {
        value.forEach((element) {
          widget.recipeBooks.add(element);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _pushAddRecipeBookPage();
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _buildBody() {
    if (widget.recipeBooks.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return PageView.builder(
        itemCount: widget.recipeBooks.length,
        controller: PageController(viewportFraction: 0.55),
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeBookColumn(index);
        });
  }

  Widget _buildRecipeBookColumn(int index) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 180, child: _buildRecipeBookImage(index)),
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(widget.recipeBooks[index].name,
                  style: TextStyle(fontSize: 18)))
        ],
      ),
      onTap: () {
        _pushRecipeListPage(index);
      },
    );
  }

  Widget _buildRecipeBookImage(int index) {
    return FutureBuilder(
      future: widget.recipeBooks[index].image,
      builder: (BuildContext context, AsyncSnapshot<ByteData?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(Uint8List.view(snapshot.data!.buffer));
        } else {
          // Recipe Book image not created yet -> display placeholder
          return SizedBox(
            height: 200,
            width: 160,
          );
        }
      },
    );
  }

  /// Pushes the page that displays the content of the recipe book
  void _pushRecipeListPage(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final _recipeBook = widget.recipeBooks[index];
      return RecipeListPage(recipeBook: _recipeBook);
    }));
  }

  /// Pushes the page that allows adding a new recipe book
  void _pushAddRecipeBookPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddRecipeBookPage();
    })).then((newRecipeBook) {
      // New RecipeBook has been created
      setState(() {
        if (newRecipeBook != null) widget.recipeBooks.add(newRecipeBook);
      });
    });
  }

  /// TEST DATA:

  /// Returns some demo recipe books
  Future<List<RecipeBook>> _getDemoRecipeBooks() async {
    RecipeBook recipeBook1 = RecipeBook(
        id: 1,
        name: "Antons Recipes",
        color: RecipeBookColor.banana,
        icon: RecipeBookIcon.cooking_hat);
    recipeBook1.recipes.addAll(await _getDemoRecipes());

    RecipeBook recipeBook2 = RecipeBook(
        name: "Felix Recipe Book",
        color: RecipeBookColor.flora,
        icon: RecipeBookIcon.ingredients);
    RecipeBook recipeBook3 = RecipeBook(
        name: "Julia's Back Rezepte",
        color: RecipeBookColor.cantaloupe,
        icon: RecipeBookIcon.dishes);
    RecipeBook recipeBook4 = RecipeBook(
        name: "Kochbuch von Silke",
        color: RecipeBookColor.carnation,
        icon: RecipeBookIcon.pan);
    RecipeBook recipeBook5 = RecipeBook(
        name: "Holgers BBQ",
        color: RecipeBookColor.salmon,
        icon: RecipeBookIcon.man);

    return [recipeBook1, recipeBook2, recipeBook3, recipeBook4, recipeBook5];
  }

  /// Returns some demo recipes
  Future<List<Recipe>> _getDemoRecipes() async {
    Recipe recipe1 = Recipe(
        name: "Bircher Müsli",
        recipeBookID: 1,
        preparationSteps: [
          "Haferflocken mit Sahne, Milch, Agaven Sirup und Naturjoghurt mischen und über Nacht zugedeckt ziehen lassen.",
          "6-Korn-Mischung in den Thermomix geben und 20 Sekunden/Stufe 7 schroten. Mit kaltem Wasser bedeckt im Mixtopf über Nacht ziehen lassen.",
          "Morgens Mandeln zu den geschroteten Körnern geben und 3 Sekunden/Stufe 6 zerkleinern.",
          "Apfel und Bananen zugeben und 3 Sekunden/Stufe 5.",
          "Zum Schluss die Haferflocken-Mischung dazugeben und 15 Sekunden/Linkslauf/Stufe 3 mischen.",
        ],
        cookingTime: 360,
        image: null,
            // (await rootBundle.load('assets/images/recipes/5acc7083e411a.jpg'))
            //     .buffer
            //     .asUint8List(),
        recipeTypes: [RecipeType.VEGETARIAN, RecipeType.DESSERT],
        preparationTime: 35);

    recipe1.ingredients = [
      Ingredient("Haferflocken", UnitAmount(Unit.GRAM, 150)),
      Ingredient("Sahne", UnitAmount(Unit.GRAM, 200)),
      Ingredient("Milch", UnitAmount(Unit.GRAM, 200)),
      Ingredient("Agaven Sirup oder Honig", UnitAmount(Unit.GRAM, 60)),
      Ingredient("Naturjoghurt", UnitAmount(Unit.GRAM, 150)),
      Ingredient("6-Korn-Mischung", UnitAmount(Unit.GRAM, 80)),
      Ingredient("Mandeln", UnitAmount(Unit.GRAM, 60)),
      Ingredient("Apfel", UnitAmount(Unit.PCS, 1)),
      Ingredient("Banane", UnitAmount(Unit.PCS, 2))
    ];

    // Recipe recipe2 = Recipe("Recipe 2");
    // Recipe recipe3 = Recipe("Recipe 3");
    // Recipe recipe4 = Recipe("Recipe 4");

    return [
      recipe1,
      // recipe2,
      // recipe3,
      // recipe4
    ];
  }
}
