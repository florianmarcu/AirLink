import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
  
  final String uid;
  final String? email;
  final String? photoURL;
  String displayName;
  final bool isAnonymous;
  String? phoneNumber;
  bool? isManager = false;
  bool? isAdmin = false;

  UserProfile({required this.uid, this.email, this.photoURL,required this.displayName, required this.isAnonymous, this.phoneNumber, required this.isManager, required this.isAdmin});
}

/// Converts a User to UserProfile
Future<UserProfile?> userToUserProfile(User? user) async{
  if(user != null){
    if(!user.isAnonymous) {
      var data = (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).data();
      var userProfile = UserProfile(
        uid: user.uid,
        email: user.email,
        photoURL: user.photoURL,
        displayName: user.displayName != null 
          ? user.displayName !
          : (user.email != null
            ? user.email!.substring(0,user.email!.indexOf('@'))
            : "Oaspete"),
        isAnonymous : user.isAnonymous,
        isManager: data!['manager'],
        isAdmin: data['admin'],
        phoneNumber: data['contact_phone_number'],
      );
      return userProfile;
    }
  }
  return null;
}
