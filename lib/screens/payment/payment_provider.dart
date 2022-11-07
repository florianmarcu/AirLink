import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/arrival_trip/arrival_trip_provider.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';

class PaymentPageProvider with ChangeNotifier{
  PaymentMethod paymentMethod = PaymentMethod.cash;
  bool isLoading = false;

  void updatePaymentMethod(PaymentMethod? paymentMethod){
    this.paymentMethod = paymentMethod!;

    notifyListeners();
  }
  

  Future<Ticket> makeReservation(Ticket ticket, dynamic returnTicket, TripPageProvider tripPageProvider, ArrivalTripPageProvider? arrivalTripPageProvider) async{
    _loading();

    var userTicketRef = FirebaseFirestore.instance.collection("users").doc(Authentication.auth.currentUser!.uid).collection("tickets").doc();
    var companyTicketRef = FirebaseFirestore.instance.collection("companies").doc(ticket.companyId).collection("tickets").doc(userTicketRef.id);
    print(tripPageProvider.selectedPassengerNumber);
    var ticketData = {
      "id" : ticket.id,
      "date_created": FieldValue.serverTimestamp(),
      "company_id": ticket.companyId,
      "company_name": ticket.companyName,
      "company_address": ticket.companyAddress,
      "departure_location_name" : ticket.departureLocationName,
      "departure_location_address": ticket.departureLocationAddress,
      "arrival_location_name": ticket.arrivalLocationName,
      "arrival_location_address": ticket.arrivalLocationAddress,
      "departure_time": Timestamp.fromDate(ticket.departureTime),
      "arrival_time": Timestamp.fromDate(ticket.arrivalTime),
      "passenger_no": tripPageProvider.selectedPassengerNumber,
      "passenger_data": tripPageProvider.passengerData,
      "phone_number": tripPageProvider.passengerData[0]['phone_number'],
      "price": ticket.price,
      "payment_method": this.paymentMethod.name,
      "user_ticket_ref": userTicketRef,
      "company_ticket_ref": companyTicketRef,
      "air_company_name": tripPageProvider.selectedAirline,
      "flight_time": tripPageProvider.selectedDepartureDateAndHour,
      // "to": tripPageProvider.passengerData.map((passenger) => passenger['email']).toList(),
      // "template": {
      //   "name": "ticket_confirmation_email_template",
      //   "data": {
      //     "ticket": {
      //       "id": ticket.id,
      //       "passengerName": tripPageProvider.passengerData[0]['name'],
      //       "companyName": ticket.companyName,
      //       "company": ticket.companyName,
      //       "companyAddress": ticket.companyAddress,
      //       "departureLocation": ticket.departureLocationName,
      //       "departureAddress": ticket.departureLocationAddress,
      //       "arrivalLocation": ticket.arrivalLocationName,
      //       "arrivalAddress":ticket.arrivalLocationAddress,
      //       "departureTime": formatDateToHourAndMinutes(ticket.departureTime),
      //       "arrivalTime": formatDateToHourAndMinutes(ticket.arrivalTime),
      //       "tripDuration": formatDurationToHoursAndMinutes(ticket.arrivalTime.difference(ticket.arrivalTime)),
      //       "class": "Economy",
      //       "luggage": formatPassengerDataToLuggage(tripPageProvider.passengerData),
      //       "departureDate": formatDateToShortDate(ticket.departureTime),
      //       "arrivalDate": formatDateToShortDate(ticket.arrivalTime),
      //       "paymentMethod": ticket.paymentMethod!.name,
      //       "price": ticket.price,
      //       "otherFees": 0,
      //       "total" : ticket.price
      //     }
      //   }
      // },
      // "message": {
      //   "subject": 'Hello from Firebase!',
      //   "text": 'This is the plaintext section of the email body.',
      //   "html": 'This is the <code>HTML</code> section of the email body.',
      // }
    };

    if(returnTicket != null && arrivalTripPageProvider != null) {
      var userReturnTicketRef = FirebaseFirestore.instance.collection("users").doc(Authentication.auth.currentUser!.uid).collection("tickets").doc();
      var companyReturnTicketRef = FirebaseFirestore.instance.collection("companies").doc(ticket.companyId).collection("tickets").doc(userReturnTicketRef.id);
      var returnTicketData = {
        "id" : returnTicket.id,
        "date_created": FieldValue.serverTimestamp(),
        "company_id": returnTicket.companyId,
        "company_name": returnTicket.companyName,
        "company_address": returnTicket.companyAddress,
        "departure_location_name" : returnTicket.departureLocationName,
        "departure_location_address": returnTicket.departureLocationAddress,
        "arrival_location_name": returnTicket.arrivalLocationName,
        "arrival_location_address": returnTicket.arrivalLocationAddress,
        "departure_time": Timestamp.fromDate(returnTicket.departureTime),
        "arrival_time": Timestamp.fromDate(returnTicket.arrivalTime),
        "passenger_no": arrivalTripPageProvider.selectedPassengerNumber,
        "passenger_data": arrivalTripPageProvider.passengerData,
        "phone_number": arrivalTripPageProvider.passengerData[0]['phone_number'],
        "price": returnTicket.price,
        "payment_method": this.paymentMethod.name,
        "user_ticket_ref": userReturnTicketRef,
        "company_ticket_ref": companyReturnTicketRef,
        "return": true,
        "air_company_name": arrivalTripPageProvider.selectedAirline,
        "flight_time": arrivalTripPageProvider.selectedDepartureDateAndHour,
      };

      ticketData.addAll({"return_ticket_ref" :  userReturnTicketRef});
      returnTicketData.addAll({"departure_ticket_ref" : userTicketRef});

      await userTicketRef.set(ticketData);
      await companyTicketRef.set(ticketData);
      await userReturnTicketRef.set(returnTicketData);
      await companyReturnTicketRef.set(returnTicketData);
    }

    else{
      await userTicketRef.set(ticketData);
      await companyTicketRef.set(ticketData);
    }
    

    _loading();

    notifyListeners();

    Authentication.updateUserPhoneNumber(ticket.passengerData![0]['phone_number']);

    return ticketDataToTicket(
      ticketData['company_id'] as String,
      ticketData['company_name'] as String,
      ticketData['company_address'] as String,
      ticket.departureTime, 
      formatDateToHourAndMinutes(ticket.departureTime)!, 
      formatDateToHourAndMinutes(ticket.arrivalTime)!, 
      ticketData
    );
  }

  _loading(){
    isLoading = !isLoading;
    
    notifyListeners();
  }
}

enum PaymentMethod{
  cash,
  card
}