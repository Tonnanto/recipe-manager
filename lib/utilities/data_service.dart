
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

  Future<String> updateRecipeBook(RecipeBook recipeBook);

  Future<String> deleteRecipeBook(String id);


  // ---------------------------------------------------------------------------
  // CRUD Operations for Recipes
  // ---------------------------------------------------------------------------

  Future<Recipe> createRecipe(Recipe recipe);

  Future<List<Recipe>> readAllRecipes();

  Future<List<Recipe>> readRecipesFromBook(String recipeBookID);

  Future<Recipe> readRecipe(Recipe recipe);

  Future<String> updateRecipe(Recipe recipe);

  Future<String> deleteRecipe(Recipe recipe);


  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  Future<Ingredient> createIngredient(Ingredient ingredient, Recipe recipe);

  Future<List<Ingredient>> readAllIngredient();

  Future<List<Ingredient>> readIngredientsFromRecipe(Recipe recipe);

  Future<String> updateIngredient(Ingredient ingredient, Recipe recipe);

  Future<String> deleteIngredient(String ingredientId, Recipe recipe);


  // ---------------------------------------------------------------------------
  // DEMO DATA
  // ---------------------------------------------------------------------------

  Future deleteAllData();

  Future resetDemoData();

  Future addDemoData();
}