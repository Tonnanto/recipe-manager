
import 'package:enum_to_string/enum_to_string.dart';

final String tableIngredients = 'ingredients';

/// Each Recipe has multiple Ingredients
class Ingredient {
  late final int? id;
  late String name;
  late final UnitAmount unitAmount;

  final int recipeID;

  Ingredient({
    this.id,
    required this.name,
    required this.unitAmount,
    required this.recipeID
  });

  static Ingredient fromMap(Map<String, Object?> map) {
    return Ingredient(
      id: map[IngredientFields.id] as int?,
      recipeID: map[IngredientFields.recipeID] as int,
      name: map[IngredientFields.name] as String,
      unitAmount: UnitAmount(EnumToString.fromString(Unit.values, map[IngredientFields.unit] as String) ?? Unit.GRAM, map[IngredientFields.amount] as double),
    );
  }

  Map<String, Object?> toMap() => {
    IngredientFields.id: id,
    IngredientFields.name: name,
    IngredientFields.amount: unitAmount.amount,
    IngredientFields.unit: EnumToString.convertToString(unitAmount.unit),
    IngredientFields.recipeID: recipeID,
  };

  /// Returns a copy of the same Ingredient with the given fields changed
  Ingredient copy({
    int? id,
    String? name,
    UnitAmount? unitAmount,
    int? recipeID,
  }) {
    Ingredient copy = Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      unitAmount: unitAmount ?? this.unitAmount,
      recipeID: recipeID ?? this.recipeID,
    );
    return copy;
  }

  bool get isValid {
    return name.isNotEmpty && unitAmount.amount > 0;
  }
}

class IngredientFields {
  static final List<String> values = [
    id, name, amount, unit, recipeID
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String amount = 'amount';
  static final String unit = 'unit';
  static final String recipeID = 'recipeID'; // Foreign Key
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