import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class WrapperProvider with ChangeNotifier{
  bool isLoading = false;
  UserProfile? user;
}