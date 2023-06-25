import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageProvider with ChangeNotifier{

  bool isLoading = false;
  String email = (Authentication.currentUser != null && !Authentication.currentUser!.isAnonymous) ? Authentication.currentUser!.email ?? "" : "";   /// Required for reauthenticating the user in case of account deletion
  String password = "";  /// Required for reauthenticating the user in case of account deletion
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> updateProfileImage() async{
    _loading();

    XFile? newImage = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);
    if(newImage != null)
      await Authentication.updateProfileImage(newImage.path);
    _loading();

    notifyListeners();
  }

  Future<bool> deleteAccount() async{
    if(formKey.currentState != null && formKey.currentState!.validate()){
      print(email);
      print(password);
      var res = await Authentication.deleteAccount(email, password);
      if(res)
        return true;
    }
    return false;
  }

  String? validateEmail(String? value){
    if(value != null && value != ""){
      return null;
    }
    else return "Trebuie să introduceți un email";
  }

  String? validatePassword(String? value){
    if(value != null && value != ""){
      return null;
    }
    else return "Trebuie să introduceți o parolă";
  }

  void updateEmail(String? value){
    email = value ?? "";

    notifyListeners();
  }

  void updatePassword(String? value){
    password = value ?? "";

    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}