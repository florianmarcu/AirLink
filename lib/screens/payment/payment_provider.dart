import 'dart:convert';
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart' as models;
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/arrival_trip/arrival_trip_provider.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
export 'package:provider/provider.dart';

class PaymentPageProvider with ChangeNotifier{
  models.PaymentMethod paymentMethod = models.PaymentMethod.cash;
  bool isLoading = false;
  CardFormEditController cardFormEditController = CardFormEditController();
  PaymentStatus paymentStatus = PaymentStatus.initial;
  CardFieldInputDetails? cardFieldInputDetails = CardFieldInputDetails(complete: false);
  UserProfile? userProfile;
  double? total = 0.0;

  PaymentPageProvider(this.userProfile, HomePageProvider homePageProvider,Ticket ticket, TripPageProvider tripPageProvider, [Ticket? returnTicket, ArrivalTripPageProvider? arrivalTripPageProvider]){
    getData(ticket, homePageProvider, tripPageProvider, returnTicket, arrivalTripPageProvider);
  }

  void getData(Ticket ticket, HomePageProvider homePageProvider, TripPageProvider tripPageProvider, [Ticket? returnTicket, ArrivalTripPageProvider? arrivalTripPageProvider]){
    _loading();
    initCardFormEditController();
    
    if(homePageProvider.selectedTransportationType == TransportationType.private){
      total =  ticket.price +
      (returnTicket != null
      ? returnTicket.price
      : 0);
    }
    else{
      total =  tripPageProvider.selectedPassengerNumber * ticket.price +
      (returnTicket != null
      ? arrivalTripPageProvider!.selectedPassengerNumber * returnTicket.price
      : 0);
    }

    _loading();
    notifyListeners();
  }

  void initCardFormEditController(){
    cardFormEditController = CardFormEditController(initialDetails: cardFieldInputDetails);
    // cardFormEditController.addListener(() { 
    //   cardFieldInputDetails = cardFormEditController.details;
    // });

    notifyListeners();
  }

  void updateCardFieldInputDetails(CardFieldInputDetails? cardFieldInputDetails){
    this.cardFieldInputDetails = cardFieldInputDetails;

    print(cardFieldInputDetails);

    notifyListeners();
  }

  void updatePaymentMethod(models.PaymentMethod? paymentMethod){
    this.paymentMethod = paymentMethod!;

    notifyListeners();
  }

  Future<bool?> pay(BuildContext context, Ticket ticket, Ticket? returnTicket, TripPageProvider tripPageProvider, ArrivalTripPageProvider? arrivalTripPageProvider) async{

    _loading();
    
    bool? result = null;

    /// Create payment method
    try{
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: Authentication.auth.currentUser!.email,
              name: Authentication.auth.currentUser!.displayName
              // email: Authentication.auth.currentUser!.email,
              // name: Authentication.auth.currentUser!.displayName,
              // address: Address(
              //   city: "Bucharest",
              //   line1: "Bulevardul Unirii 1",
              //   line2: "Bulevardul Unirii 2",
              //   postalCode: "032791",
              //   country: "Romania",
              //   state: "Romania"
              // )
            )
          ) 
        ),
      );

      var stripeConnectAccountId = await FirebaseFirestore.instance.collection('companies').doc(ticket.companyId).get().then((doc) => doc.data()!['stripe_connect_account_id']);

      var totalAmount = total!*100;
      var applicationFeeAmount = (totalAmount / 100) * ticket.applicationFee;

      // Stripe.stripeAccountId = stripeConnectAccountId;
      // await Stripe.instance.applySettings();

      final paymentIntentResults = await _callPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'ron',
        value: totalAmount,
        applicationFeeAmount: applicationFeeAmount,
        stripeConnectAccountId: stripeConnectAccountId
      );

      if(paymentIntentResults['error'] != null){
        result = null;
      }

      /// NO 3DS
      /// Payments completes succesfully
      if(paymentIntentResults['clientSecret'] != null && paymentIntentResults['requiresAction'] == null)
        result =  true;

      /// 3DS
      /// User needs to confirm the payment
      if(paymentIntentResults['clientSecret'] != null && paymentIntentResults['requiresAction'] == true){
        final String clientSecret = paymentIntentResults['clientSecret'];
        
        /// User needs to confirm the payment
        try{
          final paymentIntent = await Stripe.instance.handleNextAction(clientSecret);

          if(paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation){
            /// We make the Stripe API call
            Map<String, dynamic> results = await _callPayEndpointIntentId(paymentIntentId: paymentIntent.id);
            /// On 'results' contains an error
            if(results['error'] != null){
              return null;
            }
            else result = true;
          }
          else result = true;
        }
        catch(e) {
          print(e.toString() + " error");
          result = null;
        }

      }
      //result = true;
    }
    /// The user didn't fill the card info correctly
    on StripeException
    catch(e){ 
      print(e.error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Datele cardului nu sunt corecte"),
      ));
      result = false;
    }


    _loading();
    
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> _callPayEndpointMethodId({
    required bool useStripeSdk, 
    required String paymentMethodId,
    required String currency,
    required double value,
    required double applicationFeeAmount,
    required String stripeConnectAccountId
    }) async{
      final url = Uri.parse(
        "https://us-central1-airlink-63554.cloudfunctions.net/StripePayEndpointMethodId"
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'useStripeSdk': true,
            'paymentMethodId': paymentMethodId,
            'currency': 'ron',
            'value': value,
            'applicationFeeAmount': applicationFeeAmount,
            'stripeConnectAccountId': stripeConnectAccountId 
          }
        )
      );
      print(response.body);
      return json.decode(response.body);
  }

  Future<Map<String, dynamic>> _callPayEndpointIntentId({
    required String paymentIntentId,
    }) async{
      final url = Uri.parse(
        "https://us-central1-airlink-63554.cloudfunctions.net/StripePayEndpointIntentId"
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'paymentIntentId': paymentIntentId,
          }
        )
      );
      return json.decode(response.body);
  }



  Future<models.Ticket> makeReservation(models.Ticket ticket, dynamic returnTicket, TripPageProvider tripPageProvider, ArrivalTripPageProvider? arrivalTripPageProvider) async{
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
      "need_children_seat": tripPageProvider.needChildrenSeat,
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
        "need_children_seat": arrivalTripPageProvider.needChildrenSeat,
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

    Authentication.updateUserPhoneNumber(tripPageProvider.passengerData[0]['phone_number']);

    return models.ticketDataToTicket(
      ticketData['company_id'] as String,
      ticketData['company_name'] as String,
      ticketData['company_address'] as String,
      ticket.departureTime, 
      formatDateToHourAndMinutes(ticket.departureTime)!, 
      formatDateToHourAndMinutes(ticket.arrivalTime)!, 
      ticketData
    );
  }

  void handlePaymentError(BuildContext context, result) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("A aparut o eroare ${result}"),
    ));
  }

  _loading(){
    isLoading = !isLoading;
    
    notifyListeners();
  }

}

enum PaymentStatus{
  initial,
  loading,
  success,
  failure
}