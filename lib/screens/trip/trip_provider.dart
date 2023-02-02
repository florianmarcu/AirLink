import 'dart:convert';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TripPageProvider with ChangeNotifier{
  Ticket ticket;
  Ticket? returnTicket;
  
  List<int> passengerNumberList = [1,2,3,4,5,6,7,8];
  List<String> airlineList = ["Tarom", "Wizz Air", "Ryanair", "Blue Air", ""];
  bool isPassengerFormFieldComplete = false;
  String selectedAirline = "Tarom";
  int selectedPassengerNumber = 1;
  DateTime selectedDepartureDateAndHour = DateTime.now().toLocal();
  // String? selectedDepartureLocationAddress;
  // LatLng? selectedDepartureLocation;
  List<GlobalKey<FormFieldState>> phoneNumberFormKeys = [GlobalKey<FormFieldState>()];
  bool isLoading = false;


  List passengerData = [
    {
      "name" : Authentication.auth.currentUser!.displayName,
      "email" : Authentication.auth.currentUser!.email,
      "phone_number" : Authentication.auth.currentUser!.phoneNumber == null || Authentication.auth.currentUser!.phoneNumber == "" ? "" : Authentication.auth.currentUser!.phoneNumber,
      "luggage" : {
        "backpack" : true,
        "hand" : false,
        "check-in": false
      }
    }
  ]; 

  TripPageProvider(this.ticket, {this.returnTicket}){
    // getData();
    updateMaxPassengerCapacity();
    updatePassengerFormFieldComplete();
    selectedDepartureDateAndHour = ticket.arrivalTime;
  }

  // Future<void> getData(){
  //   _loading();

  //   this.selectedDepartureLocationAddress.departureLocationName

  //   _loading();
  //   notifyListeners();
  // }

  void updateSelectedDepartureLocation(double latitude, double longitude){
    ticket.departureLocation = LatLng(latitude, longitude);

    notifyListeners();
  }

  void updateSelectedLocationAddress(String locationAddress){
    ticket.departureLocationAddress = locationAddress;

    notifyListeners();
  }

  void getAddressForLocation(double latitude, double longitude) async{
    _loading();
    var result = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${kGoogleMapsApiKey}")
    );
    var data = json.decode(result.body);
    _loading();
  }

  void updateMaxPassengerCapacity(){
    print(ticket.capacity);
    if(ticket.capacity != null)
      passengerNumberList = passengerNumberList.sublist(0, ticket.capacity!);
  }

  void updateSelectedDepartureDateAndHour(DateTime date){
    selectedDepartureDateAndHour = DateTime(
      date.year,
      date.month,
      date.day,
      selectedDepartureDateAndHour.hour,
      selectedDepartureDateAndHour.minute
    );

    notifyListeners();
  }

  /// Method that updates the flight time (Android)
  void updateSelectedDepartureHourAndroid(TimeOfDay? time){
    if(time != null)
      selectedDepartureDateAndHour = DateTime(
        selectedDepartureDateAndHour.year,
        selectedDepartureDateAndHour.month,
        selectedDepartureDateAndHour.day,
        time.hour,
        time.minute
      );
      
    notifyListeners();
  }

  /// Method that updates the flight time (iOS)
  void updateSelectedDepartureHourIOS(DateTime time){
    selectedDepartureDateAndHour = DateTime(
      selectedDepartureDateAndHour.year,
      selectedDepartureDateAndHour.month,
      selectedDepartureDateAndHour.day,
      time.hour,
      time.minute
    );

    notifyListeners();
  }

  void updatePassengerFormFieldComplete(){
    isPassengerFormFieldComplete = passengerData.fold(true, (previousValue, element) => 
      previousValue && 
      (element['name'] != "" && element['email'] != "" && element['phone_number'] != "" && validatePassengerPhoneNumber(element['phone_number']) == null)
    );
    // print(phoneNumberFormKeys[passengerData.indexOf(passengerData[0])].currentState != null && phoneNumberFormKeys[passengerData.indexOf(passengerData[0])].currentState!.validate());
    //print(passengerData);
    // print(isPassengerFormFieldComplete.toString());
    // if(phoneNumberFormKeys[0].currentState == null) {
    //   print("este null");
    // }
    notifyListeners();
  }

  void updatePassengerDataLength(int value){
    if(passengerData.length > value) {
      passengerData = List.from(passengerData.sublist(0,value));
      //phoneNumberFormKeys = phoneNumberFormKeys.sublist(0, value);
      print(phoneNumberFormKeys[passengerData.indexOf(passengerData[0])].currentState.toString() + " before");
      phoneNumberFormKeys.removeRange(value, passengerData.length);
      print(phoneNumberFormKeys[passengerData.indexOf(passengerData[0])].currentState.toString() + " after");
    } else {
      print(passengerData.length.toString() + " sdasdasd "+ value.toString());
      for (var i = passengerData.length; i < value; i++) {
        passengerData.add({
          "name" : "",
          "email" : "",
          "phone_number" : "",
          "luggage" : {
            "backpack" : true,
            "hand" : false,
            "check-in": false
          }
        });
        phoneNumberFormKeys.add(GlobalKey<FormFieldState>());
      }
    }
    print(passengerData);

    updatePassengerFormFieldComplete();

    notifyListeners();
  }

  void updatePassengerName(int index, String name){
    passengerData[index]['name'] = name;

    notifyListeners();
  }

  void updatePassengerEmail(int index, String email){
    passengerData[index]['email'] = email;

    notifyListeners();
  }
  
  void updatePassengerPhoneNumber(int index, String phoneNumber){
    passengerData[index]['phone_number'] = phoneNumber;

    notifyListeners();
  }

  void updatePassengerLuggage(int luggage, int index, bool selected){
    switch(luggage){
      case 1: passengerData[index]['luggage']['backpack'] = selected;
      break;
      case 2: passengerData[index]['luggage']['hand'] = selected;
      break;
      case 3: passengerData[index]['luggage']['check-in'] = selected;
    }
    
    notifyListeners();
  }

  void updateSelectedPassengerNumber(value){
    if(selectedPassengerNumber != value){
      selectedPassengerNumber = value;

      ticket.passengersNo = value;

      updatePassengerDataLength(value);
    }

    notifyListeners();
  }

  void updateSelectedAirline(value){
    selectedAirline = value;

    notifyListeners();
  }

  String? validatePassengerPhoneNumber(String? phoneNumber){
    // print("numar $phoneNumber");
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (phoneNumber != null)
      if(
        (phoneNumber.startsWith("0") && phoneNumber.length != 10) || 
        (phoneNumber.startsWith("+") && phoneNumber.length != 12) ||
        (!regExp.hasMatch(phoneNumber))
      )
      return "Numărul introdus este invalid";
    return null;
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}