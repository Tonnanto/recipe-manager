import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:recipe_manager/models/demo_data.dart';
import 'package:recipe_manager/models/ingredient_model.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';
import 'package:recipe_manager/utilities/data_service.dart';

class FirebaseService implements DataService {
  static final FirebaseService instance = FirebaseService._init();

  FirebaseService._init();

  // ---------------------------------------------------------------------------
  // Converting Objects to and from Map
  // ---------------------------------------------------------------------------

  RecipeBook recipeBookFromMap(Map<String, Object?> map) => RecipeBook(
        id: map[RecipeBookFields.id] as String?,
        name: map[RecipeBookFields.name] as String,
        color: EnumToString.fromString(RecipeBookColor.values,
                map[RecipeBookFields.color] as String) ??
            RecipeBookColor.flora,
        icon: EnumToString.fromString(
                RecipeBookIcon.values, map[RecipeBookFields.icon] as String) ??
            RecipeBookIcon.ingredients,
      );

  Map<String, Object?> recipeBookToMap(RecipeBook recipeBook) => {
        RecipeBookFields.name: recipeBook.name,
        RecipeBookFields.color: EnumToString.convertToString(recipeBook.color),
        RecipeBookFields.icon: EnumToString.convertToString(recipeBook.icon),
      };

  Recipe recipeFromMap(Map<String, Object?> map) {
    List<String> recipeTypeStrings =
        (map[RecipeFields.recipeTypes] as List<dynamic>).cast<String>();
    String imageString = map[RecipeFields.image] as String;

    return Recipe(
      id: map[RecipeFields.id] as String?,
      name: map[RecipeFields.name] as String,
      recipeBookID: map[RecipeFields.recipeBookID] as String,
      preparationSteps:
          (map[RecipeFields.preparationSteps] as List<dynamic>).cast<String>(),
      recipeTypes: List.generate(
          recipeTypeStrings.length,
          (index) =>
              EnumToString.fromString(
                  RecipeType.values, recipeTypeStrings[index]) ??
              RecipeType.OTHER),
      image:
          imageString.isNotEmpty ? Base64Decoder().convert(imageString) : null,
      preparationTime: map[RecipeFields.preparationTime] as int,
      cookingTime: map[RecipeFields.cookingTime] as int,
    );
  }

  Map<String, Object?> recipeToMap(Recipe recipe) => {
        RecipeFields.name: recipe.name,
        RecipeFields.preparationSteps: recipe.preparationSteps,
        RecipeFields.recipeTypes: List.generate(recipe.recipeTypes.length,
            (index) => EnumToString.convertToString(recipe.recipeTypes[index])),
        RecipeFields.image:
            recipe.image != null ? Base64Encoder().convert(recipe.image!) : "",
        RecipeFields.preparationTime: recipe.preparationTime,
        RecipeFields.cookingTime: recipe.cookingTime,
        RecipeFields.recipeBookID: recipe.recipeBookID,
      };

  Ingredient ingredientFromMap(Map<String, Object?> map) {
    return Ingredient(
      id: map[IngredientFields.id] as String?,
      recipeID: map[IngredientFields.recipeID] as String,
      name: map[IngredientFields.name] as String,
      unitAmount: UnitAmount(
          EnumToString.fromString(
                  Unit.values, map[IngredientFields.unit] as String) ??
              Unit.GRAM,
          map[IngredientFields.amount] as double),
    );
  }

  Map<String, Object?> ingredientToMap(Ingredient ingredient) => {
        IngredientFields.name: ingredient.name,
        IngredientFields.amount: ingredient.unitAmount.amount,
        IngredientFields.unit:
            EnumToString.convertToString(ingredient.unitAmount.unit),
        IngredientFields.recipeID: ingredient.recipeID,
      };

  // ---------------------------------------------------------------------------
  // CRUD Operations for RecipeBooks
  // ---------------------------------------------------------------------------

  @override
  Future<RecipeBook> createRecipeBook(RecipeBook recipeBook) async {
    CollectionReference recipeBookCollection =
        FirebaseFirestore.instance.collection('recipe_books');

    Map<String, dynamic> recipeBookMap = recipeBookToMap(recipeBook);
    await recipeBookCollection.add(recipeBookMap).then((value) {
      recipeBook = recipeBook.copy(id: value.id);
      print("RecipeBook Added");
    }).catchError((error) {
      print("Failed to add RecipeBook: $error");
    });

    return recipeBook;
  }

  @override
  Future<List<RecipeBook>> readAllRecipeBooks() async {
    List<RecipeBook> recipeBooks = [];

    CollectionReference recipeBookCollection =
        FirebaseFirestore.instance.collection('recipe_books');
    QuerySnapshot query = await recipeBookCollection.get();

    for (QueryDocumentSnapshot doc in query.docs) {
      Map<String, Object?> recipeBookMap = doc.data() as Map<String, Object?>;

      // Adding id to map
      recipeBookMap[RecipeBookFields.id] = doc.id;

      recipeBooks.add(recipeBookFromMap(recipeBookMap));
    }
    return recipeBooks;
  }

  @override
  Future<String> updateRecipeBook(RecipeBook recipeBook) async {
    CollectionReference recipeBookCollection =
        FirebaseFirestore.instance.collection('recipe_books');

    await recipeBookCollection
        .doc('${recipeBook.id}')
        .update(recipeBookToMap(recipeBook))
        .then((value) => print("RecipeBook Updated"))
        .catchError((error) => print("Failed to update RecipeBook: $error"));

    return recipeBook.id ?? '';
  }

  @override
  Future<String> deleteRecipeBook(String id) async {
    CollectionReference recipeBookCollection =
        FirebaseFirestore.instance.collection('recipe_books');

    await recipeBookCollection
        .doc('$id')
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
    DocumentReference recipeBookDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID);
    CollectionReference recipeCollection = recipeBookDoc.collection('recipes');

    Map<String, dynamic> recipeMap = recipeToMap(recipe);
    await recipeCollection.add(recipeMap).then((value) {
      recipe = recipe.copy(id: value.id);
      print("Recipe Added");
    }).catchError((error) {
      print("Failed to add Recipe: $error");
    });

    return recipe;
  }

  @override
  Future<List<Recipe>> readAllRecipes() async {
    // TODO: implement readAllRecipes
    throw UnimplementedError();
  }

  @override
  Future<List<Recipe>> readRecipesFromBook(String recipeBookID) async {
    List<Recipe> recipes = [];

    DocumentReference recipeBookDoc =
        FirebaseFirestore.instance.collection('recipe_books').doc(recipeBookID);
    QuerySnapshot query = await recipeBookDoc.collection('recipes').get();

    for (QueryDocumentSnapshot doc in query.docs) {
      Map<String, Object?> recipeMap = doc.data() as Map<String, Object?>;

      // Adding ids to map
      recipeMap[RecipeFields.id] = doc.id;
      recipeMap[RecipeFields.recipeBookID] = recipeBookID;

      recipes.add(recipeFromMap(recipeMap));
    }

    return recipes;
  }

  @override
  Future<Recipe> readRecipe(Recipe recipe) async {
    DocumentReference recipeBookDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID);
    DocumentSnapshot recipeDoc =
        await recipeBookDoc.collection('recipes').doc(recipe.id).get();

    Map<String, Object?> recipeMap = recipeDoc.data() as Map<String, Object?>;

    // Adding ids to map
    recipeMap[RecipeFields.id] = recipeDoc.id;
    recipeMap[RecipeFields.recipeBookID] = recipe.recipeBookID;

    return recipeFromMap(recipeMap);
  }

  @override
  Future<String> updateRecipe(Recipe recipe) async {
    DocumentReference recipeBookDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID);
    CollectionReference recipeCollection = recipeBookDoc.collection('recipes');

    await recipeCollection
        .doc('${recipe.id}')
        .update(recipeToMap(recipe))
        .then((value) => print("Recipe Updated"))
        .catchError((error) => print("Failed to update Recipe: $error"));

    return recipe.id ?? '';
  }

  @override
  Future<String> deleteRecipe(Recipe recipe) async {
    DocumentReference recipeBookDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID);
    CollectionReference recipeCollection = recipeBookDoc.collection('recipes');

    await recipeCollection
        .doc('${recipe.id}')
        .delete()
        .then((value) => print("Recipe Deleted"))
        .catchError((error) => print("Failed to delete Recipe: $error"));

    return recipe.id ?? '';
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for Ingredients
  // ---------------------------------------------------------------------------

  @override
  Future<Ingredient> createIngredient(
      Ingredient ingredient, Recipe recipe) async {
    DocumentReference recipeDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID)
        .collection('recipes')
        .doc(ingredient.recipeID);
    CollectionReference ingredientsCollection =
        recipeDoc.collection('ingredients');

    Map<String, dynamic> ingredientMap = ingredientToMap(ingredient);
    await ingredientsCollection
        .add(ingredientMap)
        .then((value) => print("Ingredient Added"))
        .catchError((error) => print("Failed to add Ingredient: $error"));

    return ingredient;
  }

  @override
  Future<List<Ingredient>> readAllIngredient() async {
    // TODO: implement readAllIngredient
    throw UnimplementedError();
  }

  @override
  Future<List<Ingredient>> readIngredientsFromRecipe(Recipe recipe) async {
    List<Ingredient> ingredients = [];

    DocumentReference recipeDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID)
        .collection('recipes')
        .doc(recipe.id);
    QuerySnapshot query = await recipeDoc.collection('ingredients').get();

    for (QueryDocumentSnapshot doc in query.docs) {
      Map<String, Object?> ingredientMap = doc.data() as Map<String, Object?>;

      // Adding ids to map
      ingredientMap[IngredientFields.id] = doc.id;
      ingredientMap[IngredientFields.recipeID] = recipe.id;

      ingredients.add(ingredientFromMap(ingredientMap));
    }

    return ingredients;
  }

  @override
  Future<String> updateIngredient(Ingredient ingredient, Recipe recipe) async {
    DocumentReference recipeDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID)
        .collection('recipes')
        .doc(ingredient.recipeID);
    CollectionReference ingredientsCollection =
        recipeDoc.collection('ingredients');

    await ingredientsCollection
        .doc('${ingredient.id}')
        .update(ingredientToMap(ingredient))
        .then((value) => print("Ingredient Updated"))
        .catchError((error) => print("Failed to update Ingredient: $error"));

    return ingredient.id ?? '';
  }

  @override
  Future<String> deleteIngredient(String ingredientId, Recipe recipe) async {
    DocumentReference recipeDoc = FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipe.recipeBookID)
        .collection('recipes')
        .doc(recipe.id);
    CollectionReference ingredientsCollection =
        recipeDoc.collection('ingredients');

    await ingredientsCollection
        .doc('$ingredientId')
        .delete()
        .then((value) => print("Ingredient Deleted"))
        .catchError((error) => print("Failed to delete Ingredient: $error"));

    return ingredientId;
  }

  // ---------------------------------------------------------------------------
  // DEMO DATA
  // ---------------------------------------------------------------------------

  @override
  Future addDemoData() async {
    print("Adding Demo Data");


    List<RecipeBook> recipeBooks = await getDemoRecipeBooks();
    List<Recipe> recipes = await getDemoRecipes();
    List<Ingredient> ingredients = await getDemoIngredients();


    for (RecipeBook recipeBook in recipeBooks) {
      String? newRecipeBookId = (await createRecipeBook(recipeBook)).id;

      for (Recipe recipe in recipes.where((element) => element.recipeBookID == recipeBook.id)) {
        String? newRecipeId = (await createRecipe(recipe.copy(recipeBookID: newRecipeBookId))).id;

        for (Ingredient ingredient in ingredients.where((element) => element.recipeID == recipe.id)) {
          await createIngredient(ingredient.copy(recipeID: newRecipeId), recipe.copy(recipeBookID: newRecipeBookId));

        }
      }
    }
  }

  @override
  Future deleteAllData() async {
    CollectionReference recipeBookCollection = FirebaseFirestore.instance.collection('recipe_books');
    QuerySnapshot query = await recipeBookCollection.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot recipeBookSnap in query.docs) {
      DocumentReference recipeBookDoc = recipeBookSnap.reference;

      for (QueryDocumentSnapshot recipeSnap in (await recipeBookDoc.collection('recipes').get()).docs) {
        DocumentReference recipeDoc = recipeSnap.reference;

        for (QueryDocumentSnapshot ingredientSnap in (await recipeDoc.collection('ingredients').get()).docs) {
          DocumentReference ingredientDoc = ingredientSnap.reference;
          batch.delete(ingredientDoc);
        }
        batch.delete(recipeDoc);
      }
      batch.delete(recipeBookDoc);
    }

    await batch.commit();
  }

  @override
  Future resetDemoData() async {
    await deleteAllData();
    await addDemoData();
  }
}
