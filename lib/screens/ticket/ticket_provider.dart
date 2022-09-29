import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TicketPageProvider with ChangeNotifier{
  Ticket ticket;

  TicketPageProvider(this.ticket);
}