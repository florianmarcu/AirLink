import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
export 'package:provider/provider.dart';
import 'dart:developer';


class TripsPageProvider with ChangeNotifier{

  HomePageProvider homeProvider;
  Map<String, dynamic> activeFilters = {};

  bool isLoading = false;
  List<Ticket> allTickets = [
  ];

  List<Ticket> tickets = [];

  TripsPageProvider(this.homeProvider){
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

    var selectedDepartureLocation = homeProvider.selectedDepartureLocation;
    var selectedArrivalLocation = homeProvider.selectedArrivalLocation;
    var selectedDepartureDate = homeProvider.selectedDepartureDate;
    var selectedTransportationCompany = homeProvider.selectedTransportationCompany;
    
    /// All companies are selected
    if(selectedTransportationCompany == homeProvider.transportationCompanies.first){
      var query = await FirebaseFirestore.instance.collection("companies").get();
      for (var i = 0; i < query.docs.length; i++) {
        var companyId = query.docs[i].id;
        var companyName = query.docs[i].data()['name'];
        var companyAddress = query.docs[i].data()['address'];
        var ticketsQuery = await query.docs[i].reference.collection("available_trips")
        .where("departure_location_name", isEqualTo: selectedDepartureLocation)
        .where("arrival_location_name", isEqualTo: selectedArrivalLocation)
        .get();
        for (var j = 0; j < ticketsQuery.docs.length; j++) {
          for (var k = 0; k < ticketsQuery.docs[j].data()['schedule'].length; k++) {
            var departureTime = ticketsQuery.docs[j].data()['schedule'][k]['departure_time'];
            var arrivalTime = ticketsQuery.docs[j].data()['schedule'][k]['arrival_time'];
            ;
            log(k.toString());
            allTickets.add(ticketDataToTicket(
              companyId, /// company id
              companyName, /// company name
              companyAddress,
              selectedDepartureDate, /// departure date
              departureTime, ///departure time
              arrivalTime, /// arrival time
              ticketsQuery.docs[j].data()
            ));
          }
        }
      }
    }
    /// Only one company is selected
    else {
      var doc = await FirebaseFirestore.instance.collection("companies").doc(selectedTransportationCompany.id).get();
      var companyId = doc.id;
      var companyName = doc.data()!['name'];
      var companyAddress = doc.data()!['name'];
      var ticketsQuery = await doc.reference.collection("available_trips")
      .where("departure_location_name", isEqualTo: selectedDepartureLocation)
      .where("arrival_location_name", isEqualTo: selectedArrivalLocation)
      .get();
      for (var j = 0; j < ticketsQuery.docs.length; j++) {
        for (var k = 0; k < ticketsQuery.docs[j].data()['schedule'].length; k++) {
          var departureTime = ticketsQuery.docs[j].data()['schedule'][k]['departure_time'];
          var arrivalTime = ticketsQuery.docs[j].data()['schedule'][k]['arrival_time'];
          ;
          log(k.toString());
          allTickets.add(ticketDataToTicket(
            companyId, /// company id
            companyName, /// company name
            companyAddress,
            selectedDepartureDate, /// departure date
            departureTime, ///departure time
            arrivalTime, /// arrival time
            ticketsQuery.docs[j].data()
          ));
        }
      }
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