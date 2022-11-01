import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportation_app/models/models.dart';
export 'package:provider/provider.dart';

class WrapperProvider with ChangeNotifier{
  bool isLoading = false;
  UserProfile? user;

  void finishOnboardingScreen() async{

    await SharedPreferences.getInstance()
    .then((result) {
      result.setBool("welcome", true);
    });
    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}