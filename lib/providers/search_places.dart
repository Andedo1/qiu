import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qiu/models/auto_complete_result.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults> ((ref){
  return PlaceResults();
});

class PlaceResults extends ChangeNotifier {
  List<AutoCompleteResult> allReturnedResults = [];

  void setResults(allPlaces){
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>((ref) {
  return SearchToggle();
});

class SearchToggle extends ChangeNotifier{
  bool searchToggle = false;

  void toggleSearch(){
    searchToggle = !searchToggle;
    notifyListeners();
  }
}