import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier{
  int selectedDepartureIndex = 0;
  int selectedArrivalIndex = 0;
  var selectedDepartureLocation = "Bucuresti";
  var selectedArrivalLocation = "Aeroport International Henri Coanda";
  List<String> departureLocations = [
    "Bucuresti",
    "Ilfov"
  ];
  List<String> arrivalLocations = [
      "Aeroport International Henri Coanda",
      "Aeroport International Baneasa"
  ];
  void updateSelectedDepartureIndex(index){
    selectedDepartureLocation = index;

    notifyListeners();
  }
  void updateSelectedArrivalIndex(index){
    selectedArrivalLocation = index;

    notifyListeners();
  }
}