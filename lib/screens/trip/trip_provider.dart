import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class TripPageProvider with ChangeNotifier{
  Ticket ticket;

  TripPageProvider(this.ticket);
}