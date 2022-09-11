import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TicketListPageProvider with ChangeNotifier{

  Map<String, dynamic> activeFilters = {};

  bool isLoading = false;
  List<Ticket> allTickets = [
    Ticket(
      id: "1",
      departureLocationId: "bucharest",
      departureLocationName: "Bucuresti",
      arrivalLocationId: "ai_henri_coanda",
      arrivalLocationName: "Aeroport International Henri Coanda",
      departureTime: DateTime(2022,9,29,10,45),
      arrivalTime: DateTime(2022,9,29,12,00),
      companyId: "1",
      companyName: "Companie 1",
      price: 20
    ),
    Ticket(
      id: "2",
      departureLocationId: "bucharest",
      departureLocationName: "Bucuresti",
      arrivalLocationId: "ai_henri_coanda",
      arrivalLocationName: "Aeroport International Henri Coanda",
      departureTime: DateTime(2022,9,30,19,15),
      arrivalTime: DateTime(2022,9,30,20,00),
      companyId: "2",
      companyName: "Companie 2",
      price: 20
    ),
    Ticket(
      id: "3",
      departureLocationId: "bucharest",
      departureLocationName: "Bucuresti",
      arrivalLocationId: "ai_henri_coanda",
      arrivalLocationName: "Aeroport International Henri Coanda",
      departureTime: DateTime(2022,9,1,8,0),
      arrivalTime: DateTime(2022,9,1,9,15),
      companyId: "2",
      companyName: "Companie 3",
      price: 30
    ),
  ];

  List<Ticket> tickets = [];

  TicketListPageProvider(){
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