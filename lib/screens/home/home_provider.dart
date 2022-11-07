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
  Map<String, dynamic> availableTrips = {};
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
        addAvailableTrip(tripsQuery.docs[i].data()); 
        departureLocations.add(tripsQuery.docs[i].data()['departure_location_name']);
        arrivalLocations.add(tripsQuery.docs[i].data()['arrival_location_name']);
      }
    }
    this.transportationCompanies.addAll(transportationCompanies.toList());
    selectedTransportationCompany = this.transportationCompanies.first;
    this.departureLocations.addAll(departureLocations.toList());
    selectedDepartureLocation = this.departureLocations.first;
    // this.arrivalLocations.addAll(arrivalLocations.toList());
    updateAvailableArrivalLocations();
    selectedArrivalLocation = this.arrivalLocations.first;
    notifyListeners();
  }

  PageController pageController = PageController(initialPage: 0);
  void updateSelectedDepartureLocation(String? departureLocation){
    selectedDepartureLocation = departureLocation!;
    updateAvailableArrivalLocations();
    selectedArrivalLocation = arrivalLocations.first; 

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
  void updateAvailableArrivalLocations(){
    arrivalLocations = List.from(availableTrips[selectedDepartureLocation]);
    print(arrivalLocations);
  }

  void addAvailableTrip(Map<String, dynamic> trip){
    if(availableTrips[trip['departure_location_name']] == null)
      availableTrips[trip['departure_location_name']] = List.from([trip['arrival_location_name']]);
    else availableTrips[trip['departure_location_name']].add(trip['arrival_location_name']);  
  }
}


enum TripType{
  roundtrip,
  oneway
}