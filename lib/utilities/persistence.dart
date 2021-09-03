
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:recipe_manager/models/demo_data.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';

import 'data_service.dart';

class PersistenceService implements DataService {
  static final PersistenceService instance = PersistenceService._init();
  static Database? _database;

  PersistenceService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipe_manager.db');
    return _database!;
  }

  // ---------------------------------------------------------------------------
  // Methods for database management
  // ---------------------------------------------------------------------------

  /// Initializes DB Connection
  Future<Database> _initDB(String fileName) async {
    print("Initializing DB");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    print("DB Path: $path");
    return await openDatabase(path, version: 1, onCreate: _createDB, onConfigure: _configureDB);
  }

  Future _configureDB(Database db) async {
    print("Configuring DB");
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    print("Creating DB");
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = 'REAL NOT NULL';

    // RecipeBook Table
    String createRecipeBookTable = '''
    CREATE TABLE $tableRecipeBooks (
    ${RecipeBookFields.id} $idType, 
    ${RecipeBookFields.name} $textType,
    ${RecipeBookFields.color} $textType, 
    ${RecipeBookFields.icon} $textType
    )
    ''';
    print("Executing: \n$createRecipeBookTable");
    await db.execute(createRecipeBookTable);

    // Recipe Table
    String createRecipeTable = '''
    CREATE TABLE $tableRecipes (
    ${RecipeFields.id} $idType, 
    ${RecipeFields.name} $textType,
    ${RecipeFields.preparationSteps} $textType, 
    ${RecipeFields.recipeTypes} $textType,
    ${RecipeFields.image} $textType, 
    ${RecipeFields.preparationTime} $integerType,
    ${RecipeFields.cookingTime} $integerType, 
    ${RecipeFields.recipeBookID} $integerType,
    FOREIGN KEY(${RecipeFields.recipeBookID}) REFERENCES $tableRecipeBooks(${RecipeBookFields.id})
    ON DELETE CASCADE
    )
    ''';
    print("Executing: \n$createRecipeTable");
    await db.execute(createRecipeTable);

    // Ingredients Table
    String createIngredientsTable = '''
    CREATE TABLE $tableIngredients (
    ${IngredientFields.id} $idType, 
    ${IngredientFields.name} $textType,
    ${IngredientFields.amount} $doubleType, 
    ${IngredientFields.unit} $textType,
    ${IngredientFields.recipeID} $integerType,
    FOREIGN KEY(${IngredientFields.recipeID}) REFERENCES $tableRecipes(${RecipeFields.id})
    ON DELETE CASCADE
    )
    ''';
    print("Executing: \n$createIngredientsTable");
    await db.execute(createIngredientsTable);
  }

  /// Closes DB Connection
  Future close() async {
    print("Closing DB Connection");

    final db = await instance.database;
    db.close();
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for RecipeBooks
  // ---------------------------------------------------------------------------

  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook) async {
    print("Adding RecipeBook");
    final db = await instance.database;
    final id = await db.insert(tableRecipeBooks, recipeBook.toMap());
    return recipeBook.copy(id: id.toString());
  }

  Future<List<RecipeBook>> readAllRecipeBooks() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableRecipeBooks);
    print("All Recipe Books: \n$result");
    return result.map((map) => RecipeBook.fromMap(map)).toList();
  }

  Future<String> updateRecipeBook(RecipeBook recipeBook) async {
    final db = await instance.database;

    return (await db.update(
      tableRecipeBooks,
      recipeBook.toMap(),
      where: '${RecipeBookFields.id} = ?',
      whereArgs: [recipeBook.id],
    )).toString();
  }

  Future<String> deleteRecipeBook(String id) async {
    final db = await instance.database;

    return (await db.delete(
      tableRecipeBooks,
      where: '${RecipeBookFields.id} = ?',
      whereArgs: [id],
    )).toString();
  }


  // ---------------------------------------------------------------------------
  // CRUD Operations for Recipes
  // ---------------------------------------------------------------------------

  Future<Recipe> createRecipe(Recipe recipe) async {
    print("Adding Recipe");
    final db = await instance.database;
    final id = await db.insert(tableRecipes, recipe.toMap());
    return recipe.copy(id: id.toString());
  }

  Future<List<Recipe>> readAllRecipes() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableRecipes);
    print("All Recipes: \n$result");
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> readRecipesFromBook(String recipeBookID) async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(
      tableRecipes,
      where: '${RecipeFields.recipeBookID} = ?',
      whereArgs: [recipeBookID],
    );

    print("Recipes from Book: \n$result");
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<Recipe> readRecipe(String recipeId) async {
    final db = await instance.database;

    final result = await db.query(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipeId],
    );

    print("Recipe with ID $recipeId: \n$result");
    return Recipe.fromMap(result.first);
  }

  Future<String> updateRecipe(Recipe recipe) async {
    final db = await instance.database;

    return (await db.update(
      tableRecipes,
      recipe.toMap(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    )).toString();
  }

  Future<String> deleteRecipe(String id) async {
    final db = await instance.database;

    return (await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    )).toString();
  }


  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    print("Adding Ingredient");
    final db = await instance.database;
    final id = await db.insert(tableIngredients, ingredient.toMap());
    return ingredient.copy(id: id.toString());
  }

  Future<List<Ingredient>> readAllIngredient() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableIngredients);
    print("All Ingredients: \n$result");
    return result.map((map) => Ingredient.fromMap(map)).toList();
  }

  Future<List<Ingredient>> readIngredientsFromRecipe(String id) async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(
      tableIngredients,
      where: '${IngredientFields.recipeID} = ?',
      whereArgs: [id],
    );

    print("Ingredients from Recipe: \n$result");
    return result.map((map) => Ingredient.fromMap(map)).toList();
  }

  Future<String> updateIngredient(Ingredient ingredient) async {
    final db = await instance.database;

    return (await db.update(
      tableIngredients,
      ingredient.toMap(),
      where: '${IngredientFields.id} = ?',
      whereArgs: [ingredient.id],
    )).toString();
  }

  Future<String> deleteIngredient(String id) async {
    final db = await instance.database;

    return (await db.delete(
      tableIngredients,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    )).toString();
  }


  // ---------------------------------------------------------------------------
  // DEMO DATA
  // ---------------------------------------------------------------------------

  Future deleteAllData() async {
    // Closing DB Connection
    close();

    // Deleting DB File
    print("Deleting DB");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recipe_manager.db');
    await deleteDatabase(path);

    // Creating new DB
    _database = await _initDB('recipe_manager.db');
  }

  Future resetDemoData() async {
    await deleteAllData();
    await addDemoData();
  }

  Future addDemoData() async {
    print("Adding Demo Data");

    // Recipe Books
    List<RecipeBook> recipeBooks = await getDemoRecipeBooks();
    for (RecipeBook recipeBook in recipeBooks) {
      await createRecipeBook(recipeBook);
    }

    // Recipes
    List<Recipe> recipes = await getDemoRecipes();
    for (Recipe recipe in recipes) {
      await createRecipe(recipe);
    }

    // Ingredients
    List<Ingredient> ingredients = await getDemoIngredients();
    for (Ingredient ingredient in ingredients) {
      await createIngredient(ingredient);
    }
  }
}