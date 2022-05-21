import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _tag = "";
  double _ingredientsOnHand = 0.0;
  double _cookingDuration = 0.0;

  String get tag => _tag;
  double get ingredientOnHand => _ingredientsOnHand;
  double get cookingDuration => _cookingDuration;

  void filterSet(String tag, double ioh, double cd) {
    _tag = tag;
    _ingredientsOnHand = ioh;
    _cookingDuration = cd;
    notifyListeners();
  }
}
