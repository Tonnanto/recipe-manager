

/// The individual steps that make up a recipe.
/// RecipeSteps are ordered within a recipe and will be assigned a number when displayed.
class PreparationStep {
  String content;

  PreparationStep(this.content);
}


/// Each Recipe has multiple Ingredients
class Ingredient {
  String name;
  UnitAmount unitAmount;

  Ingredient(this.name, this.unitAmount);
}


/// A recipe can have multiple types.
/// Types can be used to filter recipes when searching
enum RecipeType {
  MAIN_DISH, DESSERT, APPETIZER, MEAT, VEGETARIAN, VEGAN, COOKING, BAKING, PASTRY, DRINK
}


/// UnitAmount is used to accurately describe the quantity of a given Ingredient
class UnitAmount {
  Unit unit;
  double amount;

  UnitAmount(this.unit, this.amount);

  @override
  String toString() {
    return "$amount " + unit.shortString();
  }
}


/// Units that can be used for ingredients within this app.
enum Unit {
  GRAM, MILLI_GRAM, PCS, MILLI_LITRE, TABLE_SPOON, TEA_SPOON,
}


extension UnitAmountExtension on Unit {
  String shortString() {
    switch (this) {
      case Unit.GRAM:
        return "g";
      case Unit.MILLI_GRAM:
        return "mg";
      case Unit.PCS:
        return "pcs";
      case Unit.MILLI_LITRE:
        return "ml";
      case Unit.TABLE_SPOON:
        return "tbsp";
      case Unit.TEA_SPOON:
        return "tsp";
    }
  }

  String longString() {
    switch (this) {
      case Unit.GRAM:
        return "gram";
      case Unit.MILLI_GRAM:
        return "milli gram";
      case Unit.PCS:
        return "piece";
      case Unit.MILLI_LITRE:
        return "milli litre";
      case Unit.TABLE_SPOON:
        return "table spoon";
      case Unit.TEA_SPOON:
        return "tea spoon";
    }
  }
}