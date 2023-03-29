import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class RegisterPageProvider with ChangeNotifier{
  String? name;
  String? email;
  String? password;
  bool passwordVisible = false;
  bool isLoading = false;
  bool? isPrivacyPolicyAgreed = false;
  bool? isTermsAndConditionsAgreed = false;


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void register(BuildContext context) async{
    _loading();
    
    try{
      if(isPrivacyPolicyAgreed != true)
        throw FirebaseAuthException(code: "privacy-policy-not-accepted"); 
      if(isTermsAndConditionsAgreed != true)
        throw FirebaseAuthException(code: "terms-and-conditions-not-accepted");
      if(formKey.currentState!.validate()){
      var result = await Authentication.registerWithEmailAndPassword(name!, email!, password!);
      if(result.runtimeType == FirebaseAuthException)
        _handleAuthError(context, result);
      else Navigator.pop(context);
    }
    } on FirebaseAuthException
    catch(err){
        _handleAuthError(context, err);
    }
    
    

    _loading();

    notifyListeners();
  }

  void updateIsPrivacyPolicyAgreed(bool? isPrivacyPolicyAgreed){
    this.isPrivacyPolicyAgreed = isPrivacyPolicyAgreed;
    
    notifyListeners();
  }

  void updateIsTermsAndConditionsAgreed(bool? isTermsAndConditionsAgreed){
    this.isTermsAndConditionsAgreed = isTermsAndConditionsAgreed;
    
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

  String? validateName(String? name){
    if(name == null || name == "")
      return "Trebuie să introduceți un nume.";
    return null;
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
    String displayedMessage = "";
    switch(error.code){
      case "user-already-exists":
        displayedMessage = "Utilizatorul există deja";break;
      case "privacy-policy-not-accepted":
        displayedMessage = "Politica de confidențialitate trebuie acceptată.";break;
      case "terms-and-conditions-not-accepted":
        displayedMessage = "Termenii și condițiile trebuie acceptate.";break;
      default:
        displayedMessage = "A intervenit o eroare, încearcă mai târziu";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(displayedMessage) 
    )).closed
    .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}