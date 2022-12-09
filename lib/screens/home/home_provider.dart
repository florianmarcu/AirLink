import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier{
  var selectedTransportationType = TransportationType.public;
  var selectedDepartureLocation;
  var selectedArrivalLocation;
  var selectedDepartureDateAndHour = DateTime.now().toLocal();
  var selectedArrivalDateAndHour = DateTime.now().add(Duration(days: 7)).toLocal();
  var selectedTransportationCompany;
  bool roundTrip = false;
  Set<String> departureLocations = {};
  Set<String> arrivalLocations = {};
  Map<String, dynamic> availableTrips = {};
  Set<Company> transportationCompanies = {
      Company(
        id: "(toate companiile)",
        name: "(toate companiile)"
      ),
  };

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
    print(departureLocations);
    notifyListeners();
  }

  PageController pageController = PageController(initialPage: 0);

  void updateAvailableOptions(String field){
    switch (field){
      case "transportation_type":
        updateAvailableDepartureLocations();
        updateAvailableArrivalLocations();
        updateAvailableCompanies();
      break;
      case "departure":
        updateAvailableArrivalLocations();
        updateAvailableCompanies();
      break;
      case "arrival":
        updateAvailableCompanies();
      break;
    }

  }


  void updateSelectedDepartureLocation(String? departureLocation){
    selectedDepartureLocation = departureLocation!;
    updateAvailableOptions('departure');
    selectedArrivalLocation = arrivalLocations.first; 
  
    notifyListeners();
  }
  void updateTransportationType(int index){
    selectedTransportationType = TransportationType.values[index];
    updateAvailableOptions('transportation_type');
    notifyListeners();
  }

  void updateSelectedArrivalLocation(String? arrivalLocation){
    selectedArrivalLocation = arrivalLocation!;

    notifyListeners();
  }
  void updateSelectedDepartureDate(DateTime date){
    selectedDepartureDateAndHour = DateTime(date.year, date.month, date.day, selectedDepartureDateAndHour.hour,  selectedDepartureDateAndHour.minute);

    notifyListeners();
  }
  void updateSelectedReturnDate(DateTime date){
    selectedArrivalDateAndHour = DateTime(date.year, date.month, date.day, selectedArrivalDateAndHour.hour,  selectedArrivalDateAndHour.minute);

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

  void updateAvailableDepartureLocations(){
    
  }

  void updateAvailableArrivalLocations(){
    arrivalLocations = Set.from(availableTrips[selectedDepartureLocation]);
    print(arrivalLocations);
  }

  void updateAvailableCompanies(){
    
  }

  /// Method that updates the flight time (Android)
  void updateSelectedDepartureHourAndroid(TimeOfDay? time){
    if(time != null)
      selectedDepartureDateAndHour = DateTime(
        selectedDepartureDateAndHour.year,
        selectedDepartureDateAndHour.month,
        selectedDepartureDateAndHour.day,
        time.hour,
        time.minute
      );
      
    notifyListeners();
  }

  /// Method that updates the flight time (iOS)
  void updateSelectedDepartureHourIOS(DateTime time){
    selectedDepartureDateAndHour = DateTime(
      selectedDepartureDateAndHour.year,
      selectedDepartureDateAndHour.month,
      selectedDepartureDateAndHour.day,
      time.hour,
      time.minute
    );

    notifyListeners();
  }

  /// Method that updates the flight time (Android)
  void updateSelectedArrivalHourAndroid(TimeOfDay? time){
    if(time != null)
      selectedArrivalDateAndHour = DateTime(
        selectedArrivalDateAndHour.year,
        selectedArrivalDateAndHour.month,
        selectedArrivalDateAndHour.day,
        time.hour,
        time.minute
      );
      
    notifyListeners();
  }

  /// Method that updates the flight time (iOS)
  void updateSelectedArrivalHourIOS(DateTime time){
    selectedArrivalDateAndHour = DateTime(
      selectedArrivalDateAndHour.year,
      selectedArrivalDateAndHour.month,
      selectedArrivalDateAndHour.day,
      time.hour,
      time.minute
    );

    notifyListeners();
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

enum TransportationType{
  public,
  private
}
var transportationTypeNames = ["Public", "Privat"];