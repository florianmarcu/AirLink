
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';

class TicketsPageProvider with ChangeNotifier{
  List<Ticket>? tickets  
  // = [
  //   Ticket(
  //     id: 1,
  //     departureLocationId: "bucharest",
  //     departureLocationName: "Bucuresti",
  //     arrivalLocationId: "ai_henri_coanda",
  //     arrivalLocationName: "Aeroport International Henri Coanda",
  //     departureTime: DateTime(2022,9,29,10,45),
  //     arrivalTime: DateTime(2022,9,29,12,00),
  //     companyId: "1",
  //     companyName: "Companie 1",
  //     price: 20,
  //     passengersNo: 2,
  //     paymentMethod: PaymentMethod.cash
  //   ),
  // ]
  ; 
  bool isLoading = false;

  TicketsPageProvider(){
    getData();
  }

  Future<void> getData() async{
    _loading();
  
    await FirebaseFirestore.instance.collection("users").doc(Authentication.auth.currentUser!.uid).collection("tickets")
    .orderBy("departure_time", descending: true)
    .get()
    .then((query) => tickets = query.docs.map((doc) => ticketDataToTicket(
      doc.data()['company_id'], 
      doc.data()['company_name'], 
      doc.data()['company_address'],
      doc.data()['departure_time'].runtimeType == Timestamp ? DateTime.fromMillisecondsSinceEpoch(doc.data()['departure_time'].millisecondsSinceEpoch) :  doc.data()['departure_time'], 
      formatDateToHourAndMinutes(doc.data()['departure_time'].runtimeType == Timestamp ? DateTime.fromMillisecondsSinceEpoch(doc.data()['departure_time'].millisecondsSinceEpoch) :  doc.data()['departure_time'])!, 
      formatDateToHourAndMinutes(doc.data()['arrival_time'].runtimeType == Timestamp ? DateTime.fromMillisecondsSinceEpoch(doc.data()['arrival_time'].millisecondsSinceEpoch) :  doc.data()['arrival_time'])!, 
      doc.data()
    )).toList());
  
    _loading();

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}