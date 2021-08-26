
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';


class PersistenceService {
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
    return recipeBook.copy(id: id);
  }

  Future<List<RecipeBook>> readAllRecipeBooks() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableRecipeBooks);
    print("All Recipe Books: \n$result");
    return result.map((map) => RecipeBook.fromMap(map)).toList();
  }

  Future<int> updateRecipeBook(RecipeBook recipeBook) async {
    final db = await instance.database;

    return db.update(
      tableRecipeBooks,
      recipeBook.toMap(),
      where: '${RecipeBookFields.id} = ?',
      whereArgs: [recipeBook.id],
    );
  }

  Future<int> deleteRecipeBook(int id) async {
    final db = await instance.database;

    // TODO: Deletion Rule? Cascade?
    return await db.delete(
      tableRecipeBooks,
      where: '${RecipeBookFields.id} = ?',
      whereArgs: [id],
    );
  }


  // ---------------------------------------------------------------------------
  // CRUD Operations for Recipes
  // ---------------------------------------------------------------------------

  Future<Recipe> createRecipe(Recipe recipe) async {
    print("Adding Recipe");
    final db = await instance.database;
    final id = await db.insert(tableRecipes, recipe.toMap());
    return recipe.copy(id: id);
  }

  Future<List<Recipe>> readAllRecipes() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableRecipes);
    print("All Recipes: \n$result");
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> readRecipesFromBook(int id) async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(
      tableRecipes,
      where: '${RecipeFields.recipeBookID} = ?',
      whereArgs: [id],
    );

    print("Recipes from Book: \n$result");
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await instance.database;

    return db.update(
      tableRecipes,
      recipe.toMap(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await instance.database;

    // TODO: Deletion Rule? Cascade?
    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }


  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    print("Adding Ingredient");
    final db = await instance.database;
    final id = await db.insert(tableIngredients, ingredient.toMap());
    return ingredient.copy(id: id);
  }

  Future<List<Ingredient>> readAllIngredient() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableIngredients);
    print("All Ingredients: \n$result");
    return result.map((map) => Ingredient.fromMap(map)).toList();
  }

  Future<List<Ingredient>> readIngredientsFromRecipe(int id) async {
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

  Future<int> updateIngredient(Ingredient ingredient) async {
    final db = await instance.database;

    return db.update(
      tableIngredients,
      ingredient.toMap(),
      where: '${IngredientFields.id} = ?',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> deleteIngredient(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );
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
    List<RecipeBook> recipeBooks = await _getDemoRecipeBooks();
    for (RecipeBook recipeBook in recipeBooks) {
      await createRecipeBook(recipeBook);
    }

    // Recipes
    List<Recipe> recipes = await _getDemoRecipes();
    for (Recipe recipe in recipes) {
      await createRecipe(recipe);
    }
  }

  /// Returns some demo recipe books
  Future<List<RecipeBook>> _getDemoRecipeBooks() async {
    RecipeBook recipeBook1 = RecipeBook(
        id: 1,
        name: "Antons Recipes",
        color: RecipeBookColor.banana,
        icon: RecipeBookIcon.cooking_hat);
    // recipeBook1.recipes.addAll(await _getDemoRecipes());

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
      id: 1,
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
      image:
      (await rootBundle.load('assets/images/recipes/5acc7083e411a.jpg'))
          .buffer
          .asUint8List(),
      recipeTypes: [RecipeType.VEGETARIAN, RecipeType.DESSERT],
      preparationTime: 35);

    recipe1.ingredients = [
      Ingredient(name: "Haferflocken", unitAmount: UnitAmount(Unit.GRAM, 150), recipeID: 1),
      Ingredient(name: "Sahne", unitAmount: UnitAmount(Unit.GRAM, 200), recipeID: 1),
      Ingredient(name: "Milch", unitAmount: UnitAmount(Unit.GRAM, 200), recipeID: 1),
      Ingredient(name: "Agaven Sirup oder Honig", unitAmount: UnitAmount(Unit.GRAM, 60), recipeID: 1),
      Ingredient(name: "Naturjoghurt", unitAmount: UnitAmount(Unit.GRAM, 150), recipeID: 1),
      Ingredient(name: "6-Korn-Mischung", unitAmount: UnitAmount(Unit.GRAM, 80), recipeID: 1),
      Ingredient(name: "Mandeln", unitAmount: UnitAmount(Unit.GRAM, 60), recipeID: 1),
      Ingredient(name: "Apfel", unitAmount: UnitAmount(Unit.PCS, 1), recipeID: 1),
      Ingredient(name: "Banane", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 1),
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