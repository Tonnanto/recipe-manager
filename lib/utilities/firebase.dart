
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';

class FirebaseService implements DataService {
  static final FirebaseService instance = FirebaseService._init();
  FirebaseService._init();

  @override
  Future<Ingredient> createIngredient(Ingredient ingredient) {
    // TODO: implement createIngredient
    throw UnimplementedError();
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) {
    // TODO: implement createRecipe
    throw UnimplementedError();
  }

  @override
  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook) {
    // TODO: implement createRecipeBook
    throw UnimplementedError();
  }

  @override
  Future<int> deleteIngredient(int id) {
    // TODO: implement deleteIngredient
    throw UnimplementedError();
  }

  @override
  Future<int> deleteRecipe(int id) {
    // TODO: implement deleteRecipe
    throw UnimplementedError();
  }

  @override
  Future<int> deleteRecipeBook(int id) {
    // TODO: implement deleteRecipeBook
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> readAllIngredient() {
    // TODO: implement readAllIngredient
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeBook>> readAllRecipeBooks() {
    // TODO: implement readAllRecipeBooks
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> readAllRecipes() {
    // TODO: implement readAllRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> readIngredientsFromRecipe(int id) {
    // TODO: implement readIngredientsFromRecipe
    throw UnimplementedError();
  }

  @override
  Future<Recipe> readRecipe(int recipeId) {
    // TODO: implement readRecipe
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> readRecipesFromBook(int recipeBookID) {
    // TODO: implement readRecipesFromBook
    throw UnimplementedError();
  }

  @override
  Future<int> updateIngredient(Ingredient ingredient) {
    // TODO: implement updateIngredient
    throw UnimplementedError();
  }

  @override
  Future<int> updateRecipe(Recipe recipe) {
    // TODO: implement updateRecipe
    throw UnimplementedError();
  }

  @override
  Future<int> updateRecipeBook(RecipeBook recipeBook) {
    // TODO: implement updateRecipeBook
    throw UnimplementedError();
  }
}