
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';

class FirebaseService implements DataService {
  static final FirebaseService instance = FirebaseService._init();
  FirebaseService._init();


  // ---------------------------------------------------------------------------
  // CRUD Operations for RecipeBooks
  // ---------------------------------------------------------------------------

  @override
  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook) async {
    CollectionReference recipeBookCollection = FirebaseFirestore.instance.collection('recipe_books');

    Map<String, dynamic> recipeBookMap = recipeBook.toMap();
    recipeBookMap.remove(RecipeBookFields.id);
    await recipeBookCollection
        .add(recipeBookMap)
        .then((value) => print("RecipeBook Added"))
        .catchError((error) => print("Failed to add RecipeBook: $error"));

    return recipeBook;
  }

  @override
  Future<List<RecipeBook>> readAllRecipeBooks() async {
    List<RecipeBook> recipeBooks = [];

    CollectionReference recipeBookCollection = FirebaseFirestore.instance.collection('recipe_books');
    QuerySnapshot query = await recipeBookCollection.get();

    print(query.docs.length);

    for (QueryDocumentSnapshot doc in query.docs) {
      String id = doc.id;
      String name = doc.get('name') as String;
      RecipeBookIcon icon = EnumToString.fromString(RecipeBookIcon.values, doc.get('icon') as String) ?? RecipeBookIcon.values.first;
      RecipeBookColor color = EnumToString.fromString(RecipeBookColor.values, doc.get('color') as String) ?? RecipeBookColor.values.first;
      RecipeBook recipeBook = RecipeBook(name: name, color: color, icon: icon);
      recipeBooks.add(recipeBook.copy(id: id));
    }

    return recipeBooks;
  }

  @override
  Future<String> updateRecipeBook(RecipeBook recipeBook) async {
    // TODO: implement updateRecipeBook
    throw UnimplementedError();
  }

  @override
  Future<String> deleteRecipeBook(String id) async {
    CollectionReference recipeBookCollection = FirebaseFirestore.instance.collection('recipe_books');

    await recipeBookCollection.doc('$id')
        .delete()
        .then((value) => print("RecipeBook Deleted"))
        .catchError((error) => print("Failed to delete RecipeBook: $error"));

    return id;
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for Recipes
  // ---------------------------------------------------------------------------

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    // TODO: implement createRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> readAllRecipes() async {
    // TODO: implement readAllRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> readRecipesFromBook(String recipeBookID) async {
    // TODO: implement readRecipesFromBook
    throw UnimplementedError();
  }

  @override
  Future<Recipe> readRecipe(String recipeId) async {
    // TODO: implement readRecipe
    throw UnimplementedError();
  }

  @override
  Future<String> updateRecipe(Recipe recipe) async {
    // TODO: implement updateRecipe
    throw UnimplementedError();
  }

  @override
  Future<String> deleteRecipe(String id) async {
    // TODO: implement deleteRecipe
    throw UnimplementedError();
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  @override
  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    // TODO: implement createIngredient
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> readAllIngredient() async {
    // TODO: implement readAllIngredient
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> readIngredientsFromRecipe(String id) async {
    // TODO: implement readIngredientsFromRecipe
    throw UnimplementedError();
  }

  @override
  Future<String> updateIngredient(Ingredient ingredient) async {
    // TODO: implement updateIngredient
    throw UnimplementedError();
  }

  @override
  Future<String> deleteIngredient(String id) async {
    // TODO: implement deleteIngredient
    throw UnimplementedError();
  }

  // ---------------------------------------------------------------------------
  // DEMO DATA
  // ---------------------------------------------------------------------------

  @override
  Future addDemoData() async {
    // TODO: implement addDemoData
    throw UnimplementedError();
  }

  @override
  Future deleteAllData() async {
    // TODO: implement deleteAllData
    throw UnimplementedError();
  }

  @override
  Future resetDemoData() async {
    // TODO: implement resetDemoData
    throw UnimplementedError();
  }
}