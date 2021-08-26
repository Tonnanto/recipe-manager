
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';

void main() async {

  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'recipe_database.db'),
  );
}

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB, onConfigure: _configureDB);
  }

  Future _configureDB(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final recipeBookReferenceType = 'REFERENCES ';

    // RecipeBook Table
    await db.execute('''
    CREATE TABLE $tableRecipeBooks (
    ${RecipeBookFields.id} $idType, 
    ${RecipeBookFields.name} $textType,
    )
    ''');

    // Recipe Table
    await db.execute('''
    CREATE TABLE $tableRecipes (
    ${RecipeFields.id} $idType, 
    ${RecipeFields.name} $textType,
    ${RecipeFields.preparationSteps} $textType, 
    ${RecipeFields.recipeTypes} $textType,
    ${RecipeFields.image} $textType, 
    ${RecipeFields.preparationTime} $integerType,
    ${RecipeFields.cookingTime} $integerType, 
    ${RecipeFields.recipeBookID} $idType,
    FOREIGN KEY(${RecipeFields.recipeBookID}) REFERENCES $tableRecipeBooks(${RecipeBookFields.id}))
    )
    ''');
  }

  /// Closes DB Connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for RecipeBooks
  // ---------------------------------------------------------------------------

  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook) async {
    final db = await instance.database;
    final id = await db.insert(tableRecipeBooks, recipeBook.toMap());
    return recipeBook.copy(id: id);
  }

  Future<List<RecipeBook>> readAllRecipeBooks() async {
    final db = await instance.database;

    // TODO: Order?
    // final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableRecipeBooks);
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
}