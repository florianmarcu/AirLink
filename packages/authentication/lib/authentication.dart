import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
export 'package:firebase_auth/firebase_auth.dart';

/// A singleton class that handles the entire authentication process of the app
class Authentication{
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static User? currentUser;

  /// Auth state of the app as a stream
  static Stream<User?> get user{
    
    return auth.authStateChanges();
  }

  /// Creates a new user document in the Firestore for a new signed up user
  static void updateUserData(User user, [String? credentialProvider]) async{
    DocumentReference ref = _db.collection('users').doc(user.uid);
    DocumentSnapshot doc = await ref.get();
    //await _saveDeviceToken(user.uid);
    if(doc.data() == null){
      ref.set({
        'uid' : user.uid,
        'email' : user.email,
        'photoURL' : user.photoURL,
        'display_name' : (user.displayName != null || user.isAnonymous == true) ? user.displayName : user.email!.substring(0,user.email!.indexOf('@')),
        'date_registered': FieldValue.serverTimestamp(),
        'provider': credentialProvider
        },
        SetOptions(merge: true)
      );
    }
  }
  
  static Future signInAnonimously() async{
    try{
      UserCredential result = await auth.signInAnonymously();
      return result;
    }
    catch(error){
      print(error);
      return error;
    }
  }
  
  // Sign in with Google
  static Future signInWithGoogle() async{
    try{
      var googleSignIn = GoogleSignIn();  
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, 
        accessToken: googleAuth.accessToken
      );
      UserCredential result = await auth.signInWithCredential(credential);
      if(result.user != null)
        updateUserData(result.user!,'email_and_password');
      return result;
    }
    catch(error){
      print(error);
      return error;
    }
  }

  // Sign in with Google
  static Future signInWithFacebook() async{
    try{
      final LoginResult facebookLoginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      final AuthCredential credential = FacebookAuthProvider.credential(
        facebookLoginResult.accessToken!.token
      );
      UserCredential result = await auth.signInWithCredential(credential);
      if(result.user != null)
        updateUserData(result.user!,'facebook');
      return result;
    }
    catch(error){
      print(error);
      return error;
    }
  }

  // Sign in by email and password
  static Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    }
    catch(error){
      print(error);
      return error;
    }
  }

  /// Register with email and password
  static Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result.user != null)
        updateUserData(result.user!,'email_and_password');
      return result;
    }
    catch(error){
      return error;
    }
  }

  /// Sign out
  static Future signOut() async{
    try{
      await auth.signOut();
    }
    catch(error){
      return(error);
    }
  }

  Authentication._init(){
    user.listen((user) {
      currentUser = user;
      print(currentUser!.uid);
    });
  }
  static final Authentication _instance = Authentication._init();
  factory Authentication() => _instance;

}