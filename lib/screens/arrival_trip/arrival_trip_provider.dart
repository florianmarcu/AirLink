import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
export 'package:provider/provider.dart';

class ArrivalTripPageProvider with ChangeNotifier{
  Ticket ticket;
  Ticket returnTicket;
  TripPageProvider tripPageProvider;
  
  List<int> passengerNumberList = [1,2,3,4,5,6,7,8];
  List<String> airlineList = ["Tarom", "Wizz Air", "Ryanair", "Blue Air"];
  bool isPassengerFormFieldComplete = false;
  String selectedAirline = "Tarom";
  int selectedPassengerNumber = 1;
  DateTime selectedDepartureDateAndHour = DateTime.now().toLocal();
  List<GlobalKey<FormFieldState>> phoneNumberFormKeys = [GlobalKey<FormFieldState>()];


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

  ArrivalTripPageProvider(this.ticket, this.tripPageProvider, {required this.returnTicket}){
    passengerData = List.from(tripPageProvider.passengerData);
    phoneNumberFormKeys = List.from(tripPageProvider.phoneNumberFormKeys);
    selectedPassengerNumber = tripPageProvider.passengerData.length;
    isPassengerFormFieldComplete = tripPageProvider.isPassengerFormFieldComplete;
    //updatePassengerFormFieldComplete();
    selectedDepartureDateAndHour = returnTicket.arrivalTime;
    // selectedDepartureDateAndHour = returnTicket.departureTime;
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
    print(isPassengerFormFieldComplete);
    notifyListeners();
  }

  void updatePassengerDataLength(int value){
    if(passengerData.length > value) {
      passengerData = List.from(passengerData.sublist(0,value));
      phoneNumberFormKeys = phoneNumberFormKeys.sublist(0, value);
    } else {
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
      case 1: passengerData[index]['luggage']['backpack-'] = selected;
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

      returnTicket.passengersNo = value;

      updatePassengerDataLength(value);
    }

    notifyListeners();
  }

  void updateSelectedAirline(value){
    selectedAirline = value;

    notifyListeners();
  }

  String? validatePassengerPhoneNumber(String? phoneNumber){
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
}