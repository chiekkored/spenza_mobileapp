import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _tag = "";
  double _ingredientsOnHand = 0.0;
  double _cookingDuration = 0.0;
  int _tagIndex = 0;

  String get tag => _tag;
  double get ingredientOnHand => _ingredientsOnHand;
  double get cookingDuration => _cookingDuration;
  int get tagIndex => _tagIndex;

  void filterSet(String tag, int tagIndex, double ioh, double cd) {
    _tag = tag;
    _tagIndex = tagIndex;
    _ingredientsOnHand = ioh;
    _cookingDuration = cd;
    notifyListeners();
  }
}
