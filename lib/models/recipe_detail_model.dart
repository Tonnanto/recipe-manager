

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

/// UnitAmount is used to accurately describe the quantity of a given Ingredient
class UnitAmount {
  Unit unit;
  double amount;

  UnitAmount(this.unit, this.amount);
}

/// Units that can be used for ingredients within this app.
enum Unit {
  GRAM, MILLI_GRAM, PCS, MILLI_LITRE, TABLE_SPOON, TEA_SPOON
}

/// A recipe can have multiple types.
/// Types can be used to filter recipes when searching
enum RecipeType {
  MAIN_DISH, DESSERT, APPETIZER, MEAT, VEGETARIAN, VEGAN, COOKING, BAKING, PASTRY, DRINK
}