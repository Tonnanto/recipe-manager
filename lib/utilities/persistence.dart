
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
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

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final recipeBookReferenceType = 'REFERENCES ';

    await db.execute('''
    CREATE TABLE $tableRecipeBooks (
    ${RecipeBookFields.id} $idType, 
    ${RecipeBookFields.name} $textType,
    )
    ''');
  }
}