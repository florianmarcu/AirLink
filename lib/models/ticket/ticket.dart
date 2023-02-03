import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ticket{
  int? id;
  String? departureLocationId;
  String departureLocationName;
  String departureLocationAddress;
  LatLng departureLocation;
  String? arrivalLocationId;
  String arrivalLocationName;  
  String arrivalLocationAddress;
  LatLng arrivalLocation;
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
  double roundTripPriceDiscount;
  TicketStatus? status;
  bool cancelled;
  String? photoURL;
  List<dynamic>? types;
  int? capacity;
  double applicationFee;
  bool? needChildrenSeat;

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
    required this.roundTripPriceDiscount,
    required this.status,
    required this.cancelled,
    this.photoURL,
    this.types,
    this.capacity,
    required this.applicationFee,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.needChildrenSeat
  });

}

enum PaymentMethod{
  cash,
  card
}

enum TicketStatus{
  past,
  upcoming,
}

Ticket ticketDataToTicket(String companyId, String companyName, String companyAddress, DateTime departureDay, String departureTime, String arrivalTime, Map<String, dynamic> data){
  var departureDate = DateTime(departureDay.year, departureDay.month, departureDay.day, int.parse(departureTime.substring(0,2)), int.parse(departureTime.substring(3,5)));
  var arrivalDate = arrivalTime.compareTo(departureTime) > 0 
  ? DateTime(departureDay.year, departureDay.month, departureDay.day, int.parse(arrivalTime.substring(0,2)), int.parse(arrivalTime.substring(3,5)))
  : DateTime(departureDate.add(Duration(days: 1)).year, departureDate.add(Duration(days: 1)).month, departureDate.add(Duration(days: 1)).day, int.parse(arrivalTime.substring(0,2)), int.parse(arrivalTime.substring(3,5)));
  var id = generateId();
  TicketStatus status = departureDate.compareTo(DateTime.now().toLocal()) > 0 ? TicketStatus.upcoming : TicketStatus.past;
  bool cancelled = (data['cancelled'] != null && data['cancelled'] == true) ? true : false; 
  print(cancelled.toString() + "cancelled" + data['id'].toString());
  return Ticket(
    id: data['id'] != null ? data['id'] : id,
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
    paymentMethod: data['payment_method'] != null ? (data['payment_method'] == "cash" ? PaymentMethod.cash: PaymentMethod.card) : PaymentMethod.cash,
    passengersNo: data['passenger_no'],
    passengerData: data['passenger_data'],
    userTicketRef: data['user_ticket_ref'],
    companyTicketRef: data['company_ticket_ref'],
    airCompanyName: data['air_company_name'],
    roundTripPriceDiscount: data['round_trip_price_discount'] == null ? 0 : data['round_trip_price_discount'].toDouble(),
    status: status,
    cancelled: cancelled,
    photoURL: data['photo_url'],
    types: data['types'],
    capacity: data['capacity'],
    applicationFee: data['application_fee'] != null ? data['application_fee'].toDouble() : 0,
    arrivalLocation: LatLng(data['arrival_location'].latitude, data['arrival_location'].longitude),
    departureLocation: LatLng(data['departure_location'].latitude,  data['departure_location'].longitude),
    needChildrenSeat: data['need_children_seat']
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