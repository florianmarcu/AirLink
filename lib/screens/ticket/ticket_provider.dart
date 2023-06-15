import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TicketPageProvider with ChangeNotifier{
  Ticket ticket;
  bool isLoading = false;

  TicketPageProvider(this.ticket);

  Future<void> cancelTicket(BuildContext context) async{
    _loading();
    var now = DateTime.now().toLocal();
    var threshold = 24;
    if(ticket.departureTime.difference(now) < Duration(hours: threshold)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        "Rezervarea nu poate fi anulată cu mai puțin de $threshold ore înainte."
      )));
    }

    else{
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Biletul a fost anulat."
          ),
        )
      );
    }


    _loading();
    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;
  }
}