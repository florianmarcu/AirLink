import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier{
  var selectedDepartureLocation = "Bucuresti (toate locațiile)";
  var selectedArrivalLocation = "Aeroport International Henri Coanda";
  var selectedDepartureDate = DateTime.now().toLocal();
  var selectedTransportationCompany = "(toate companiile)";
  List<String> departureLocations = [
    "Bucuresti (toate locațiile)",
    "Bucuresti - Piata Unirii",
    "Ilfov"
  ];
  List<String> arrivalLocations = [
      "Aeroport International Henri Coanda",
      "Aeroport International Baneasa"
  ];
  List<String> transportationCompanies = [
      "(toate companiile)",
      "Companie 1",
      "Companie 2",
  ];

  PageController pageController = PageController(initialPage: 0);

  void updateSelectedDepartureIndex(index){
    selectedDepartureLocation = index;

    notifyListeners();
  }
  void updateSelectedArrivalIndex(index){
    selectedArrivalLocation = index;

    notifyListeners();
  }
  void updateSelectedDepartureLocation(String? departureLocation){
    selectedDepartureLocation = departureLocation!;

    notifyListeners();
  }
  void updateSelectedArrivalLocation(String? arrivalLocation){
    selectedArrivalLocation = arrivalLocation!;

    notifyListeners();
  }
  void updateSelectedDepartureDate(DateTime date){
    selectedDepartureDate = date;

    notifyListeners();
  }
  void updateSelectedTransportationCompany(String? transportationCompany){
    selectedTransportationCompany = transportationCompany!;

    notifyListeners();
  }
}