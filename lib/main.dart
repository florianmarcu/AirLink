import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/stripe_connect_redirect/stripe_connect_redirect_page.dart';
import 'package:transportation_app/screens/wrapper/wrapper.dart';
import 'package:transportation_app/screens/wrapper/wrapper_provider.dart';

void main() async{
  await config();
  runApp(Main());
}

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(  
          value: Authentication.user, 
          initialData: null
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AirLink',
        theme: theme(context),
        home: ChangeNotifierProvider(
          create: (_) => WrapperProvider(),
          child: Wrapper()
        ),
        onGenerateRoute: (settings){
          try{
            print(settings.name! + settings.arguments.toString());
          }
          catch(e){print (e);}
          return MaterialPageRoute(builder: (context) => StripeConnectRedirectPage());
        },
      )
    );
  }
}

Future<void> config() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  // await db();
}

Future<void> db() async{
  await FirebaseFirestore.instance.collectionGroup("available_trips").get().then((query) => query.docs.forEach((doc) {
    doc.reference.set({
      "child_seat_price": 40
    },
    SetOptions(merge: true));
  }));
  // await FirebaseFirestore.instance.collectionGroup('tickets').get().then((query) => query.docs.forEach((doc) { 
  //   if(doc.data()['arrival_location_name'] == "Aeroport International Henri Coanda")
  //     doc.reference.set({
  //       "arrival_location": GeoPoint(44.570914012204554, 26.084938011347685)
  //     }, SetOptions(merge: true));
  //   else if(doc.data()['departure_location_name'] == "Aeroport International Henri Coanda"){
  //     doc.reference.set({
  //       "departure_location": GeoPoint(44.570914012204554, 26.084938011347685)
  //     }, SetOptions(merge: true));
  //   }

  //   if(doc.data()['arrival_location_name'] == "Constanta")
  //     doc.reference.set({
  //       "arrival_location": GeoPoint(44.159843409856265, 28.636184436779125)
  //     }, SetOptions(merge: true));
  //   else if(doc.data()['departure_location_name'] == "Constanta"){
  //     doc.reference.set({
  //       "departure_location": GeoPoint(44.159843409856265, 28.636184436779125)
  //     }, SetOptions(merge: true));
  //   }

  //   if(doc.data()['arrival_location_name'] == "Tulcea")
  //     doc.reference.set({
  //       "arrival_location": GeoPoint(45.17136147152622, 28.79117687296845)
  //     }, SetOptions(merge: true));
  //   else if(doc.data()['departure_location_name'] == "Tulcea"){
  //     doc.reference.set({
  //       "departure_location": GeoPoint(45.17136147152622, 28.79117687296845)
  //     }, SetOptions(merge: true));
  //   }
  // }));

  // await FirebaseFirestore.instance.collection("companies").get().then((query) => query.docs.forEach((doc) async{
  //   await doc.reference.collection('available_trips').get().then((q) {
  //     q.docs.forEach((d) {d.reference.set({"application_fee": 3}, SetOptions(merge: true)); });      
  //   }
  //   );
  // }));
  var query = await FirebaseFirestore.instance.collection("companies").doc("kirvad").collection("available_trips").get();
  query.docs.forEach((doc) { 
    doc.reference.set(
      {
        "round_trip_discount": 0
      },
      SetOptions(merge: true)
    );
  });
}