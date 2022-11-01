import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class ConfirmNewPasswordPageProvider with ChangeNotifier{
  String email;
  String password = "";
  String confirmedPassword = "";
  String code = "";
  bool isLoading = false;

  ConfirmNewPasswordPageProvider(this.email);

  void setPassword(String password){
    password = password;

    notifyListeners();
  }
  void setConfirmedPassword(String confirmedPassword){
    confirmedPassword = confirmedPassword;

    notifyListeners();
  }
  void setCode(String code){
    code = code;

    notifyListeners();
  }
  Future<void> confirmPasswordReset(BuildContext context) async{
    _loading();

    if(password != confirmedPassword)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Parola confirmată nu corespunde"),
        )
      );
    else try{
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: password
      ).then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
    on FirebaseAuthException
    catch(err){
      _handleError(context, err.code);
    }

    _loading();

    notifyListeners();
  }

  void _handleError(BuildContext context, String code){
    switch (code){
        case 'expired-action-code': 
          _showErrorSnackBar(context, "Codul a expirat");
        break;
        case 'invalid-action-code':
          _showErrorSnackBar(context, "Codul este invalid");
        break;
        case 'user-disabled':
          _showErrorSnackBar(context, "Utilizatorul a fost dezactivat");
        break;
        case 'user-not-found':
          _showErrorSnackBar(context, "Utilizatorul nu a fost găsit");
        break;
        case 'weak-password':
          _showErrorSnackBar(context, "Parola este prea slabă");
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