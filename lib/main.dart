import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/wrapper/wrapper.dart';
import 'package:transportation_app/screens/wrapper/wrapper_provider.dart';
import 'package:transportation_app/config/.env';

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
  Stripe.publishableKey = stripePublishableKey;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  // await db();
}

Future<void> db() async{
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