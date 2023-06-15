import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_provider.dart';

class PrivateArrivalTripsPageProvider with ChangeNotifier{
  Ticket departureTicket;
  HomePageProvider homePageProvider;
  Map<String, dynamic> activeFilters = {};

  bool isLoading = false;
  List<Ticket> allTickets = [
  ];

  List<Ticket> tickets = [];

  PrivateArrivalTripsPageProvider(this.homePageProvider, this.departureTicket){
    getData();
  }

  Future<void> getData() async{
    _loading();

    activeFilters = {
      // "types": kFilters['types']!.map((e) => false).toList(),
      // "ambiences": kFilters['ambiences']!.map((e) => false).toList(),
      // "costs": kFilters['costs']!.map((e) => false).toList(),
      "sorts": kFilters['sorts']!.map((e) => false).toList(),
    };
    allTickets = [];

    var selectedTransportationType = homePageProvider.selectedTransportationType;
    var selectedDepartureLocation = homePageProvider.selectedArrivalLocation;
    var selectedArrivalLocation = homePageProvider.selectedDepartureLocation;
    var selectedDepartureDate = homePageProvider.selectedArrivalDateAndHour;
    var selectedTransportationCompany = this.departureTicket.companyId;

    var doc = (await FirebaseFirestore.instance.collection("companies").where("id", isEqualTo: departureTicket.companyId).get()).docs[0];
    var companyId = departureTicket.companyId!;
    var companyName = departureTicket.companyName;
    var companyAddress = departureTicket.companyAddress;
    var ticketsQuery = await doc.reference.collection("available_trips")
    .where("departure_location_name", isEqualTo: selectedDepartureLocation)
    .where("arrival_location_name", isEqualTo: selectedArrivalLocation)
    .where("type", isEqualTo: selectedTransportationType.name)
    .get();
    print(ticketsQuery.docs.length);
    for (var j = 0; j < ticketsQuery.docs.length; j++) {
      print(j);
      allTickets.add(ticketDataToTicket(
        companyId, /// company id
        companyName, /// company name
        companyAddress,
        selectedDepartureDate, /// departure date
        formatDateToHourAndMinutes(selectedDepartureDate)!, ///departure time
        formatDateToHourAndMinutes(selectedDepartureDate.add(Duration(minutes: ticketsQuery.docs[j].data()['duration'])))!, /// arrival time
        ticketsQuery.docs[j].data()
      ));
    }

    tickets = List.from(allTickets);

    _loading();

    notifyListeners();
  }

  void filter(
    Map<String, List<bool>> filters, 
    // WrapperHomePageProvider wrapperHomePageProvider
  ) async{
    _loading();

    activeFilters = Map<String, List<bool>>.from(filters);
    
    Map<String, List<String>> finalFilters = {
      // "types" : [], "ambiences" : [], "costs": [], 
      "sorts": []
    };
    kFilters.forEach((key, list) {
      for(int i = 0; i < list.length; i++)
      if(filters[key]![i])
        finalFilters[key]!.add(list[i]);
    });
    // List.copyRange(places, 0, allPlaces);
    tickets = List.from(allTickets);

    // places = allPlaces;

    //tickets.forEach((element) {print(element.types);});
    
    filters.forEach((key, list) {
      for(int i = 0; i < list.length; i++){
        if(list[i]){
          var value = kFilters[key]![i];          
          switch(key){
            // case "types":
            //   tickets.removeWhere((place) => !place.types!.contains(value));
            // break;
            // case "ambiences":
            //   tickets.removeWhere((place) => place.ambience != value);
            // break;
            // case "costs":
            //   tickets.removeWhere((place) => place.cost.toString() != value);
            //   break;
            case "sorts":
              tickets.sort((a,b) => a.arrivalTime.difference(a.departureTime).inMinutes - b.arrivalTime.difference(b.departureTime).inMinutes );
            break;
          }
        }
      }
    });

    // markers = await _mapPlacesToMarkers(places);

    notifyListeners();
    _loading();
  }

  void removeFilters() async{
    _loading();
     /// Instantiate active filters with no 'false' for each field
    activeFilters = {
      // "types": kFilters['types']!.map((e) => false).toList(),
      // "ambiences": kFilters['ambiences']!.map((e) => false).toList(),
      // "costs": kFilters['costs']!.map((e) => false).toList(),
      "sorts" : kFilters['sorts']!.map((e) => false).toList(),
    };
    /// Reinstantiate displayed places with all places
    tickets = List.from(allTickets);
    /// Map displayed places to Markers
    // markers = await _mapPlacesToMarkers(places);

    notifyListeners();
    _loading();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}