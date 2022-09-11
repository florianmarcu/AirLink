import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class RegisterPageProvider with ChangeNotifier{
  String? name;
  String? email;
  String? password;
  bool passwordVisible = false;
  bool isLoading = false;

  void register(BuildContext context) async{
    _loading();
    
    var result = await Authentication.registerWithEmailAndPassword(name!, email!, password!);
    if(result.runtimeType == FirebaseAuthException)
      _handleAuthError(context, result);
    else Navigator.pop(context);

    _loading();

    notifyListeners();
  }

  void setName(String? name){
    this.name = name;

    notifyListeners();
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

  /// Upon any error returned by the sign-in methods, shows a SnackBar accordignly
  void _handleAuthError(BuildContext context, FirebaseAuthException error){
    var errorCodeToText = {
      "email-already-in-use": "Există deja un cont asocial cu această adresă de email", 
      "invalid-email": "Emailul introdus este invalid", 
      "operation-not-allowed": "Serviciul nu este disponibil momentan", 
      "weak-password": "Parola este prea slabă"
    };
    print(error.code);
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