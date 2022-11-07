import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TicketPageProvider with ChangeNotifier{
  Ticket ticket;
  bool isLoading = false;

  TicketPageProvider(this.ticket);

  Future<void> cancelTicket() async{
    _loading();

    await ticket.userTicketRef!.set(
      {
        "cancelled" : true
      },
      SetOptions(merge: true)
    );

    await ticket.companyTicketRef!.set(
      {
        "cancelled" : true
      },
      SetOptions(merge: true)
    );

    ticket.cancelled = true;

    _loading();
    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;
  }
}