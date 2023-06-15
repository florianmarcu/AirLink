import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_provider.dart';

class PrivateTripsPageProvider with ChangeNotifier{
  
  HomePageProvider homePageProvider;
  Map<String, dynamic> activeFilters = {};

  List<Ticket> allTickets = [];
  List<Ticket> tickets = [];

  bool isLoading = false;
  
  PrivateTripsPageProvider(this.homePageProvider){
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
    var selectedDepartureLocation = homePageProvider.selectedDepartureLocation;
    var selectedArrivalLocation = homePageProvider.selectedArrivalLocation;
    var selectedDepartureDate = homePageProvider.selectedDepartureDateAndHour;
    var selectedTransportationCompany = homePageProvider.selectedTransportationCompany;

     /// All companies are selected
    if(selectedTransportationCompany == homePageProvider.transportationCompanies.first){
      var query = await FirebaseFirestore.instance.collection("companies").get();
      for (var i = 0; i < query.docs.length; i++) {
        var companyId = query.docs[i].id;
        var companyName = query.docs[i].data()['name'];
        var companyAddress = query.docs[i].data()['address'];
        var ticketsQuery = await query.docs[i].reference.collection("available_trips")
        .where("departure_location_name", isEqualTo: selectedDepartureLocation)
        .where("arrival_location_name", isEqualTo: selectedArrivalLocation)
        .where("type", isEqualTo: selectedTransportationType.name)
        .get();
        for (var j = 0; j < ticketsQuery.docs.length; j++) {
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
      .where("type", isEqualTo: selectedTransportationType.name)
      .get();
      for (var j = 0; j < ticketsQuery.docs.length; j++) {
        ;
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
    }
    tickets = List.from(allTickets);

    _loading();

    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}