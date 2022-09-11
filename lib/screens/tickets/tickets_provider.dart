
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';

class TicketsPageProvider with ChangeNotifier{
  List<Ticket>? tickets = [
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
  ];

  TicketsPageProvider(){
    getData();
  }

  Future<void> getData() async{

  }
}