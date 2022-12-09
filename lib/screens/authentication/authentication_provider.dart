import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class AuthenticationPageProvider with ChangeNotifier{

  String? email;
  String? password;
  bool passwordVisible = false;
  bool isLoading = false;
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void logIn(BuildContext context, String signInMethod) async{
    _loading();

    // ignore: prefer_typing_uninitialized_variables
    var result;
    switch(signInMethod){
      case "email_and_password":
        if(formKey.currentState!.validate())
          result = await Authentication.signInWithEmailAndPassword(email!, password!);
      break;
      case "anonimously":
        result = await Authentication.signInAnonimously();
      break;
      case "google":
        result = await Authentication.signInWithGoogle();
      break;
      case "facebook":
        result = await Authentication.signInWithFacebook();
      break;
    }

    if(result.runtimeType == FirebaseAuthException)
      // ignore: curly_braces_in_flow_control_structures
      _handleAuthError(context, result);

    notifyListeners();

    _loading();
  }

  void setEmail(String? email){
    this.email = email;

    notifyListeners();
  }

  void setPassword(String? password){
    this.password = password;

    notifyListeners();
  }

  void setPasswordVisibility(){
    passwordVisible = !passwordVisible;

    notifyListeners();
  }

  String? validateEmail(String? email){
    if(email == null || email == "")
      return "Trebuie să introduceți un email.";
    return null;

  }

  String? validatePassword(String? password){
    if(password == null || password == "")
      return "Trebuie să introduceți o parolă.";
    return null;
  }

  /// Upon any error returned by the sign-in methods, shows a SnackBar accordignly
  void _handleAuthError(BuildContext context, FirebaseAuthException error){
    var errorCodeToText = {
      "invalid-email": "Emailul introdus este invalid", 
      "user-disabled": "Contul introdus este dezactivat", 
      "user-not-found": "Nu există utilizator pentru emailul introdus", 
      "wrong-password": "Combinația de email și parolă este greșită",
      "network-request-failed": "Eroare de conexiune"
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorCodeToText[error.code]!),
      )
    ).closed
    .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}