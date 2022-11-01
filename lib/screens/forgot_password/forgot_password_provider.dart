import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/screens/confirm_new_password/confirm_new_password_page.dart';
import 'package:transportation_app/screens/confirm_new_password/confirm_new_password_provider.dart';
export 'package:provider/provider.dart';

class ForgotPasswordPageProvider with ChangeNotifier{
  String email = "";
  bool isLoading = false;

  void setEmail(String email){
    this.email = email;
    print(email);

    notifyListeners();
  }
  Future<void> sendPasswordResetEmail(BuildContext context) async{
    _loading();
    print(email);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
      .then((_) => Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ConfirmNewPasswordPageProvider(email),
          child: ConfirmNewPasswordPage()
        )
      )));
    }
    on FirebaseAuthException
    catch(err){
      print(err);
      _handleError(context, err.code);
    }

    _loading();

    notifyListeners();
  }

  void _handleError(BuildContext context, String code){
    switch (code){
        case 'auth/invalid-email': 
          _showErrorSnackBar(context, "Emailul este invalid");
        break;
        case 'auth/missing-android-pkg-name':
          _showErrorSnackBar(context, "A apărut o problemă");
        break;
        case 'auth/missing-continue-uri':
          _showErrorSnackBar(context, "A apărut o problemă");
        break;
        case 'auth/missing-ios-bundle-id':
          _showErrorSnackBar(context, "A apărut o problemă");
        break;
        case 'auth/invalid-continue-uri':
          _showErrorSnackBar(context, "A apărut o problemă");
        break;
        case 'auth/unauthorized-continue-uri':
          _showErrorSnackBar(context, "A apărut o problemă");
        break;
        case 'auth/user-not-found':
          _showErrorSnackBar(context, "Utilizatorul nu a fost găsit");
        break;
      }
  }

  void _showErrorSnackBar(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      )
    );
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}