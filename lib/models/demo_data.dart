

import 'package:flutter/services.dart';
import 'package:recipe_manager/models/recipe_book_model.dart';
import 'package:recipe_manager/models/recipe_model.dart';

import 'ingredient_model.dart';

/// Returns some demo recipe books
Future<List<RecipeBook>> getDemoRecipeBooks() async {
  RecipeBook recipeBook1 = RecipeBook(
      id: 1,
      name: "Antons Recipes",
      color: RecipeBookColor.banana,
      icon: RecipeBookIcon.cooking_hat);

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
Future<List<Recipe>> getDemoRecipes() async {
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
      (await rootBundle.load('assets/images/recipes/demoRecipe1.jpg'))
          .buffer
          .asUint8List(),
      recipeTypes: [RecipeType.VEGETARIAN, RecipeType.DESSERT],
      preparationTime: 35
  );

  Recipe recipe2 = Recipe(
      id: 2,
      name: "Salami, Jalapeño & Olive Pizza with Honey",
      recipeBookID: 1,
      preparationSteps: [
        "Heat oven to 500° F.",
        "Let pizza dough come to room temperature for 30 minutes before rolling out onto a lightly !oured surface with a rolling pin.",
        "When your dough is roughly 10 inches in diameter or 1⁄2 inch thick, place it on a lightly oiled baking sheet, pizza pan, or pre-heated pizza stone.",
        "To make the everything bagel seasoning, mix all ingredients in a small bowl and set aside.",
        "Spoon pizza sauce (to desired thin or thickness) onto dough leaving 1-inch of crust exposed around the edges. Cover the sauce with 3⁄4 of the mozzarella cheese.",
        "Place the salami, onion, jalapeños, and olives onto the pizza. Sprinkle with remaining cheese.",
        "Brush edges of pizza with olive oil and sprinkle with the everything bagel seasoning.",
        "Place pizza in the oven for 10-12 minutes until edges are golden brown and the center of the crust is crispy.",
        "Remove from oven, drizzle with honey and sprinkle with red pepper !akes. Serve with extra honey for dipping the crust into.",
      ],
      cookingTime: 12,
      image:
      (await rootBundle.load('assets/images/recipes/demoRecipe2.jpg'))
          .buffer
          .asUint8List(),
      recipeTypes: [RecipeType.BAKING, RecipeType.MAIN_DISH],
      preparationTime: 20
  );

  Recipe recipe3 = Recipe(
      id: 3,
      name: "Fluffige Taler zum eintunken: Zucchinipuffer mit Feta und Tzatziki",
      recipeBookID: 1,
      preparationSteps: [
        "Zucchini trimmen und raspeln. In ein Sieb geben und mit 1 EL Salz vermengen, ca. 5 Minuten ziehen lassen.",
        "Feta zerkrümeln. Dill, Petersilie und Jalapeno hacken. Ei verquirlen",
        "Zucchiniraspeln mit den Händen ausdrücken und mit Feta, Kräutern, Jalapeno und Ei vermengen. Mehl nach und nach unterrühren und mit Salz und Pfeffer abschmecken.",
        "Öl in einer Pfanne erhitzen. Einige Löffel Zucchinimasse in die Pfanne geben und zu Talern formen. Im heißen Öl 5-7 Minuten knusprig ausbacken, auf Küchenpapier abtropfen lassen. Mit Tzatziki servieren.",
      ],
      cookingTime: 10,
      image:
      (await rootBundle.load('assets/images/recipes/demoRecipe3.jpg'))
          .buffer
          .asUint8List(),
      recipeTypes: [RecipeType.COOKING, RecipeType.VEGETARIAN, RecipeType.SNACK],
      preparationTime: 5
  );

  Recipe recipe4 = Recipe(
      id: 4,
      name: "Beste Moussaka",
      recipeBookID: 1,
      preparationSteps: [
        "Die Auberginen und die Zucchini in ca 0,5 cm dicke Scheiben schneiden, mit Salz bestreuen und ca 20 - 30 Minuten Flüssigkeit entziehen lassen.",
        "Währenddessen das Hackfleisch mit Olivenöl krümelig braten. Dann die klein geschnittenen Karotten, Zwiebeln und Knoblauch hinzugeben und ca. 2 Minuten mitbraten. Danach Kreuzkümmel, Paprikapulver, 1 EL Gemüsebrühe, Oregano und Pfeffer dazugeben und alles gut miteinander vermischen. Mit geschlossenem Deckel ca. 2 Minuten weiter dünsten. Danach die geschälten Tomaten samt Saft hinzugeben und mit einem Küchenhelfer in der Pfanne zerstückeln. Dann nochmals ca 3 - 4 Minuten weiter dünsten. Die Pfanne mit geschlossenem Deckel beiseite stellen und die Gewürze einziehen lassen.",
        "Nun den Backofen auf 180 Grad vorheizen (Umluft ca 160-170 Grad).",
        "Die Auberginen und Zucchini portionsweise in einer Pfanne ohne Öl anbraten. Dabei die Scheiben mit einem Pinsel leicht mit Olivenöl bepinseln. Die Scheiben wenden und danach auf Küchenpapier abtropfen lassen.",
        "In einer Schüssel die 3 Eier, 1 EL Gemüsebrühe, 150 ml Milch sowie 500 g Quark verrühren, bis eine klumpenfreie Flüssigkeit entsteht.",
        "In einem tiefen Bräter den Boden mit der Hälfte der Auberginen und Zucchini belegen. Danach das Hackfleisch, darüber die klein gewürfelten Mozzarellascheiben und darüber ca 2/3 der Eier-Quark-Milch-Flüssigkeit verteilen, mit Muskat und Pfeffer würzen. Diesen Vorgang mit einer weiteren Lage wiederholen und den Bräter für 45 Minuten in den Backofen geben.",
        "Nach Ende der Backzeit 5 Minuten abkühlen lassen. Aufschneiden, servieren und genießen.",
      ],
      cookingTime: 45,
      image:
      (await rootBundle.load('assets/images/recipes/demoRecipe4.jpg'))
          .buffer
          .asUint8List(),
      recipeTypes: [RecipeType.COOKING, RecipeType.BAKING, RecipeType.MAIN_DISH],
      preparationTime: 40
  );

  Recipe recipe5 = Recipe(
      id: 5,
      name: "Türkischer Brotschmaus",
      recipeBookID: 1,
      preparationSteps: [
        "Knoblauch und Petersilie 8 Sek./ Stufe 5",
        "Schafskäse dazu und 10 Sek./ Stufe 4",
        "Ajvar und Frischkäse dazu und 10 Sek./ Stufe 4",
      ],
      cookingTime: 0,
      image: null,
      recipeTypes: [RecipeType.THERMOMIX, RecipeType.SAUCE_DIP],
      preparationTime: 5
  );


  return [
    recipe1,
    recipe2,
    recipe3,
    recipe4,
    recipe5
  ];
}

/// Returns some demo ingredients
Future<List<Ingredient>> getDemoIngredients() async {
  return [
    // Recipe 1: Bircher Müsli
    Ingredient(name: "Haferflocken", unitAmount: UnitAmount(Unit.GRAM, 150), recipeID: 1),
    Ingredient(name: "Sahne", unitAmount: UnitAmount(Unit.MILLI_LITRE, 200), recipeID: 1),
    Ingredient(name: "Milch", unitAmount: UnitAmount(Unit.MILLI_LITRE, 200), recipeID: 1),
    Ingredient(name: "Agaven Sirup oder Honig", unitAmount: UnitAmount(Unit.GRAM, 60), recipeID: 1),
    Ingredient(name: "Naturjoghurt", unitAmount: UnitAmount(Unit.GRAM, 150), recipeID: 1),
    Ingredient(name: "6-Korn-Mischung", unitAmount: UnitAmount(Unit.GRAM, 80), recipeID: 1),
    Ingredient(name: "Mandeln", unitAmount: UnitAmount(Unit.GRAM, 60), recipeID: 1),
    Ingredient(name: "Apfel", unitAmount: UnitAmount(Unit.PCS, 1), recipeID: 1),
    Ingredient(name: "Banane", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 1),

    // Recipe 2: Salami, Jalapeño & Olive Pizza with Honey
    Ingredient(name: "Pizza Dough", unitAmount: UnitAmount(Unit.GRAM, 454), recipeID: 2),
    Ingredient(name: "Pizza Sauce", unitAmount: UnitAmount(Unit.GRAM, 400), recipeID: 2),
    Ingredient(name: "Mozzarella", unitAmount: UnitAmount(Unit.GRAM, 375), recipeID: 2),
    Ingredient(name: "Salami", unitAmount: UnitAmount(Unit.PCS, 20), recipeID: 2),
    Ingredient(name: "Red Onion", unitAmount: UnitAmount(Unit.PCS, 0.25), recipeID: 2),
    Ingredient(name: "Jalapeño", unitAmount: UnitAmount(Unit.PCS, 1), recipeID: 2),
    Ingredient(name: "Castelvetrano olives", unitAmount: UnitAmount(Unit.GRAM, 120), recipeID: 2),
    Ingredient(name: "Olive oil", unitAmount: UnitAmount(Unit.MILLI_LITRE, 20), recipeID: 2),
    Ingredient(name: "Honey", unitAmount: UnitAmount(Unit.MILLI_LITRE, 60), recipeID: 2),
    Ingredient(name: "Red Pepper flakes", unitAmount: UnitAmount(Unit.GRAM, 5), recipeID: 2),

    // Recipe 3: Fluffige Taler zum eintunken: Zucchinipuffer mit Feta und Tzatziki
    Ingredient(name: "Zucchini", unitAmount: UnitAmount(Unit.GRAM, 450), recipeID: 3),
    Ingredient(name: "Feta", unitAmount: UnitAmount(Unit.GRAM, 150), recipeID: 3),
    Ingredient(name: "Dill", unitAmount: UnitAmount(Unit.GRAM, 60), recipeID: 3),
    Ingredient(name: "Petersilie", unitAmount: UnitAmount(Unit.GRAM, 40), recipeID: 3),
    Ingredient(name: "Ei", unitAmount: UnitAmount(Unit.PCS, 1), recipeID: 3),
    Ingredient(name: "Mehl", unitAmount: UnitAmount(Unit.GRAM, 30), recipeID: 3),
    Ingredient(name: "Öl", unitAmount: UnitAmount(Unit.TABLE_SPOON, 2), recipeID: 3),
    Ingredient(name: "Tzatziki", unitAmount: UnitAmount(Unit.GRAM, 200), recipeID: 3),

    // Recipe 4: Beste Moussaka
    Ingredient(name: "Hackfleisch, gemischt", unitAmount: UnitAmount(Unit.GRAM, 500), recipeID: 4),
    Ingredient(name: "Auberginen", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 4),
    Ingredient(name: "Zucchini", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 4),
    Ingredient(name: "Karotten", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 4),
    Ingredient(name: "Zwiebel", unitAmount: UnitAmount(Unit.PCS, 2), recipeID: 4),
    Ingredient(name: "geschläte Tomaten", unitAmount: UnitAmount(Unit.GRAM, 350), recipeID: 4),
    Ingredient(name: "Knoblauch", unitAmount: UnitAmount(Unit.PCS, 3), recipeID: 4),
    Ingredient(name: "Kreuzkümmel", unitAmount: UnitAmount(Unit.TEA_SPOON, 0.5), recipeID: 4),
    Ingredient(name: "Paprikapulver, mild", unitAmount: UnitAmount(Unit.TEA_SPOON, 1), recipeID: 4),
    Ingredient(name: "Gemüsebrühe", unitAmount: UnitAmount(Unit.TABLE_SPOON, 2), recipeID: 4),
    Ingredient(name: "Salz", unitAmount: UnitAmount(Unit.SPRINKLE, 2), recipeID: 4),
    Ingredient(name: "Pfeffer, dunkel", unitAmount: UnitAmount(Unit.SPRINKLE, 2), recipeID: 4),
    Ingredient(name: "Muskatnuss, frisch gerieben", unitAmount: UnitAmount(Unit.SPRINKLE, 1), recipeID: 4),
    Ingredient(name: "Mozzarella", unitAmount: UnitAmount(Unit.GRAM, 250), recipeID: 4),
    Ingredient(name: "Magerquark", unitAmount: UnitAmount(Unit.GRAM, 250), recipeID: 4),
    Ingredient(name: "Oregano", unitAmount: UnitAmount(Unit.TABLE_SPOON, 1), recipeID: 4),
    Ingredient(name: "Eier", unitAmount: UnitAmount(Unit.PCS, 3), recipeID: 4),
    Ingredient(name: "Olivenöl", unitAmount: UnitAmount(Unit.MILLI_LITRE, 40), recipeID: 4),
    Ingredient(name: "Milch", unitAmount: UnitAmount(Unit.MILLI_LITRE, 150), recipeID: 4),

    // Recipe 5: Türkischer Brotschmaus
    Ingredient(name: "Knoblauch", unitAmount: UnitAmount(Unit.PCS, 1), recipeID: 5),
    Ingredient(name: "Petersilie", unitAmount: UnitAmount(Unit.GRAM, 50), recipeID: 5),
    Ingredient(name: "Schafskäse", unitAmount: UnitAmount(Unit.GRAM, 100), recipeID: 5),
    Ingredient(name: "Ajvar", unitAmount: UnitAmount(Unit.GRAM, 100), recipeID: 5),
    Ingredient(name: "Frischkäse", unitAmount: UnitAmount(Unit.GRAM, 200), recipeID: 5),
  ];
}