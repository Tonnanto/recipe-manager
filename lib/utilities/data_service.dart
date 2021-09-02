
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/persistence.dart';

import 'firebase.dart';

abstract class DataService {

  static final DataService instance = DataService.getInstance();

  static DataService getInstance() {
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return PersistenceService.instance;
    } else {
      return FirebaseService.instance;
    }
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for RecipeBooks
  // ---------------------------------------------------------------------------

  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook);

  Future<List<RecipeBook>> readAllRecipeBooks();

  Future<int> updateRecipeBook(RecipeBook recipeBook);

  Future<int> deleteRecipeBook(int id);


  // ---------------------------------------------------------------------------
  // CRUD Operations for Recipes
  // ---------------------------------------------------------------------------

  Future<Recipe> createRecipe(Recipe recipe);

  Future<List<Recipe>> readAllRecipes();

  Future<List<Recipe>> readRecipesFromBook(int recipeBookID);

  Future<Recipe> readRecipe(int recipeId);

  Future<int> updateRecipe(Recipe recipe);

  Future<int> deleteRecipe(int id);


  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  Future<Ingredient> createIngredient(Ingredient ingredient);

  Future<List<Ingredient>> readAllIngredient();

  Future<List<Ingredient>> readIngredientsFromRecipe(int id);

  Future<int> updateIngredient(Ingredient ingredient);

  Future<int> deleteIngredient(int id);


  // ---------------------------------------------------------------------------
  // DEMO DATA
  // ---------------------------------------------------------------------------

  Future deleteAllData();

  Future resetDemoData();

  Future addDemoData();
}