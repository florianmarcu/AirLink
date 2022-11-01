import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier{
  var selectedDepartureLocation;
  var selectedArrivalLocation;
  var selectedDepartureDate = DateTime.now().toLocal();
  var selectedArrivalDate = DateTime.now().add(Duration(days: 7)).toLocal();
  var selectedTransportationCompany;
  bool roundTrip = false;
  List<String> departureLocations = [
    // "Bucuresti (toate locațiile)",
    // "Bucuresti - Piata Unirii",
    // "Ilfov"
  ];
  List<String> arrivalLocations = [
      // "Aeroport International Henri Coanda",
      // "Aeroport International Baneasa"
  ];
  List<Company> transportationCompanies = [
      Company(
        id: "(toate companiile)",
        name: "(toate companiile)"
      ),
      // "Companie 1",
      // "Companie 2",
  ];

  HomePageProvider(){
    getData();
  }

  Future<void> getData() async{
    var companiesQuery = await FirebaseFirestore.instance.collection("companies").get();
    var transportationCompanies = Set<Company>();
    var departureLocations = Set<String>();
    var arrivalLocations = Set<String>();
    for (var i = 0; i < companiesQuery.docs.length; i++) {
      transportationCompanies.add(Company(id: companiesQuery.docs[i].id, name: companiesQuery.docs[i].data()['name']));
      var tripsQuery = await companiesQuery.docs[i].reference.collection('available_trips').get();
      for (var i = 0; i < tripsQuery.docs.length; i++) {
        departureLocations.add(tripsQuery.docs[i].data()['departure_location_name']);
        arrivalLocations.add(tripsQuery.docs[i].data()['arrival_location_name']);
      }
    }
    this.transportationCompanies.addAll(transportationCompanies.toList());
    this.departureLocations.addAll(departureLocations.toList());
    this.arrivalLocations.addAll(arrivalLocations.toList());
    selectedDepartureLocation = this.departureLocations.first;
    selectedArrivalLocation = this.arrivalLocations.first;
    selectedTransportationCompany = this.transportationCompanies.first;
    notifyListeners();
  }

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
  void updateSelectedReturnDate(DateTime date){
    selectedArrivalDate = date;

    notifyListeners();
  }
  void updateSelectedTransportationCompany(Company? transportationCompany){
    selectedTransportationCompany = transportationCompany!;

    notifyListeners();
  }
  void updateRoundTrip(bool roundTrip){
    this.roundTrip = roundTrip;

    notifyListeners();
  }
}

enum TripType{
  roundtrip,
  oneway
}