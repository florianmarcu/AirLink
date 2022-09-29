import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transportation_app/config/config.dart';
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
      )
    );
  }
}

Future<void> config() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  //await db();
}

Future<void> db() async{
  var query = await FirebaseFirestore.instance.collection("companies").doc("al1").collection("available_trips").get();
  var doc = query.docs.firstWhere((element) => element.data()['departure_location_name'] == "Constanta");
  var ref = FirebaseFirestore.instance.collection("companies").doc("al2").collection("available_trips").doc("sNJ8STZP4TsMoYqCyaQD");
  ref.set(
    {
      "departure_location_name" : "Tulcea",
      "arrival_location_name": "Aeroport International Henri Coanda",
      "price":  140,
      "round_trip_price": 260, 
      "extra_luggage_price": 0,
      "pet_price": 0,
      "schedule": doc.data()['schedule']
    },
    SetOptions(merge: true)
  );
}