import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
import 'package:tuple/tuple.dart';
export 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier{
  var selectedTransportationType = TransportationType.economic;
  var selectedDepartureLocation;
  var selectedArrivalLocation;
  var selectedDepartureDateAndHour = DateTime.now().toLocal().add(Duration(hours: 12));
  var selectedArrivalDateAndHour = DateTime.now().add(Duration(days: 7)).toLocal();
  var selectedTransportationCompany;
  bool roundTrip = false;
  Set<String> departureLocations = {};
  Set<String> arrivalLocations = {};
  /// Structure is {
  ///   "departure_location" : {
  ///     Tuple("arrival_location", "company", "type"),
  ///     ...
  ///   }
  /// }
  Map<String, Set<Tuple3<String, Company, TransportationType>>> availableTrips = {};
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
      var company = Company(id: companiesQuery.docs[i].id, name: companiesQuery.docs[i].data()['name']);
      transportationCompanies.add(company);
      var tripsQuery = await companiesQuery.docs[i].reference.collection('available_trips').get();
      for (var i = 0; i < tripsQuery.docs.length; i++) {
        addAvailableTrip(tripsQuery.docs[i].data(), company, tripsQuery.docs[i].data()['type'] == TransportationType.private.name ? TransportationType.private : TransportationType.economic); 
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

    updateAvailableOptions('transportation_type');
    
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

    notifyListeners();
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
    updateAvailableOptions('arrival');
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
    arrivalLocations = Set.from(availableTrips[selectedDepartureLocation]!.map((e) => e.item1));

    notifyListeners();
  }

  void updateAvailableCompanies(){
    transportationCompanies = {
      Company(
        id: "(toate companiile)",
        name: "(toate companiile)"
      ),
    };
    for(int i = 0; i < availableTrips.length; i++){
      var departureLocation = availableTrips.keys.toList()[i];
      var trips = availableTrips.values.toList()[i].toList();
      if(departureLocation == selectedDepartureLocation)
        for(int j = 0; j < trips.length; j++){
          var trip = trips[j];
          if(trip.item1 == selectedArrivalLocation && trip.item3 == selectedTransportationType)
              transportationCompanies.add(trip.item2);
        }
    }
    try{
      selectedTransportationCompany = transportationCompanies.firstWhere((company) => company.id == selectedTransportationCompany.id);
    }
    catch(e){
      selectedTransportationCompany = transportationCompanies.first;
    }
    notifyListeners();
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

  void addAvailableTrip(Map<String, dynamic> trip, Company company, TransportationType type){
    if(availableTrips[trip['departure_location_name']] == null)
      availableTrips[trip['departure_location_name']] = {Tuple3(trip['arrival_location_name'], company, type)};
    else availableTrips[trip['departure_location_name']]!.add(Tuple3(trip['arrival_location_name'], company, type));  
  }
}


enum TripType{
  roundtrip,
  oneway
}

enum TransportationType{
  economic,
  private
}
var transportationTypeNames = ["Economic", "Privat"];