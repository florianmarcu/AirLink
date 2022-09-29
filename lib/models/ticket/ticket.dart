import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket{
  int? id;
  String? departureLocationId;
  String departureLocationName;
  String departureLocationAddress;
  String? arrivalLocationId;
  String arrivalLocationName;  
  String arrivalLocationAddress;
  DateTime departureTime;
  DateTime arrivalTime;
  String? companyId;
  String companyName;
  String companyAddress;
  double price;
  int? passengersNo;
  PaymentMethod? paymentMethod;
  String? airCompanyName;
  DateTime? flightTime;
  List<dynamic>? passengerData = [];
  DocumentReference? userTicketRef;
  DocumentReference? companyTicketRef;

  Ticket({
    this.id,
    this.departureLocationId,
    required this.departureLocationName,
    required this.departureLocationAddress,
    this.arrivalLocationId,
    required this.arrivalLocationName,
    required this.arrivalLocationAddress,
    required this.departureTime,
    required this.arrivalTime,
    this.companyId,
    required this.companyName,
    required this.companyAddress,
    required this.price,
    this.passengersNo,
    this.paymentMethod,
    this.airCompanyName,
    this.flightTime,
    this.passengerData,
    this.userTicketRef,
    this.companyTicketRef,
  });

}

enum PaymentMethod{
  cash,
  card
}

Ticket ticketDataToTicket(String companyId, String companyName, String companyAddress, DateTime departureDay, String departureTime, String arrivalTime, Map<String, dynamic> data){
  var departureDate = DateTime(departureDay.year, departureDay.month, departureDay.day, int.parse(departureTime.substring(0,2)), int.parse(departureTime.substring(3,5)));
  var arrivalDate = arrivalTime.compareTo(departureTime) > 0 
  ? DateTime(departureDay.year, departureDay.month, departureDay.day, int.parse(arrivalTime.substring(0,2)), int.parse(arrivalTime.substring(3,5)))
  : DateTime(departureDate.add(Duration(days: 1)).year, departureDate.add(Duration(days: 1)).month, departureDate.add(Duration(days: 1)).day, int.parse(arrivalTime.substring(0,2)), int.parse(arrivalTime.substring(3,5)));
  var id = generateId();
  return Ticket(
    id: id,
    departureLocationName: data['departure_location_name'],
    departureLocationAddress: data['departure_location_address'],
    arrivalLocationName: data['arrival_location_name'],
    arrivalLocationAddress: data['arrival_location_address'],
    departureTime: departureDate,
    arrivalTime: arrivalDate,
    companyName: companyName,
    companyId: companyId,
    companyAddress: companyAddress,
    price: data['price'].toDouble(),
    paymentMethod: PaymentMethod.cash,
    passengersNo: data['passenger_no'],
    passengerData: data['passenger_data'],
    userTicketRef: data['user_ticket_ref'],
    companyTicketRef: data['company_ticket_ref'],
    airCompanyName: data['air_company_name']
  );
}

int generateId(){
  var n = 0;
  for(int i = 0; i < 6; i++){
    n *= 10;
    n += Random().nextInt(10);
  }
  return n;
}