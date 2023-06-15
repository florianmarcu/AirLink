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
  await db();
}

Future<void> db() async{
  // await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: "florian.marcu23@gmail.com")
  // .get().then((value) async{
  //   if(value.docs.length == 1){
  //     var doc = value.docs[0];
  //     await doc.reference.collection('tickets').get().then((value) {
  //       value.docs.forEach((element) async {
  //         if(element.data()['arrival_location'] == null || element.data()['departure_location'] == null){
  //           await element.data()['company_ticket_ref']?.delete();
  //           await element.reference.delete();
  //         }
  //       });
  //     });
  //   }
  // });
  // await FirebaseFirestore.instance.collection('companies')
  // .doc('al1')
  // .collection('available_trips')
  // .get()
  // .then((query) {
  //   query.docs.forEach((doc) async{ 
  //     await FirebaseFirestore.instance.collection('companies')
  //     .doc('kirvad')
  //     .collection('available_trips')
  //     .doc()
  //     .set(
  //       doc.data(),
  //       SetOptions(merge: true)
  //     ); 
  //   });
  // });

  // await FirebaseFirestore.instance.collection('companies')
  // .doc('kirvad')
  // .collection('available_trips')
  // .get()
  // .then((query) {
  //   query.docs.forEach((doc) {
  //     if(doc.data()['type'] == "economic")
  //     doc.reference.set(
  //       {
  //         'destinations': [
  //           "23 AUGUST",
  //           "2 CANTOANE",
  //           "AGIGEA",
  //           "AGIGHIOL",
  //           "ALBESTI",
  //           "AMZACEA",
  //           "BABADAG",
  //           "BAIA",
  //           "BUCU",
  //           "CALARASI",
  //           "CASTELU",
  //           "CATALOI",
  //           "CERNAVODA",
  //           "CIUCUROVA",
  //           "COMANA",
  //           "CORBU",
  //           "COSTINESTI",
  //           'CUMPANA',
  //           "DRAJNA NOUA",
  //           'DULCESTI',
  //           'EFORIE NORD',
  //           'EFORIE SUD',
  //           'FACLIA',
  //           'FETESTI',
  //           'GARLICIU',
  //           'GIURGENI',
  //           'HARSOVA',
  //           'JURILOVCA',
  //           'LAZU',
  //           'LIMANU',
  //           'LUMINA',
  //           'MAMAIA',
  //           'MAMAIA SAT',
  //           'MANGALIA',
  //           'MEDGIDIA',
  //           'MIHAIL KOGALNICEANU',
  //           'MIRCEA VODA',
  //           'MOSNENI',
  //           'MURFATLAR',
  //           'NALBANT',
  //           'NAVODARI',
  //           'NEGRU VODA',
  //           'NEPTUN',
  //           'NICOLAE BALCESCU',
  //           'NISIPARI',
  //           'OLIMP',
  //           'OVIDIU',
  //           'PALAZU MARE',
  //           'PECINEAGA',
  //           'PITESTI',
  //           'POARTA ALBA',
  //           'POIANA',
  //           'RAMNICU VALCEA',
  //           'SALIGNY',
  //           'SARAIU',
  //           'SARICHIOI',
  //           'SATU NOU',
  //           'SLAVA RUSA',
  //           'SLOBOZIA',
  //           'ST. CEL MARE',
  //           'TANDAREI',
  //           'TECHIRGHIOL',
  //           'TOPOLOG',
  //           'TOPRAISAR',
  //           'TULCEA',
  //           'TUZLA',
  //           'VALU LUI TRAIAN',
  //           'VENUS',
  //           'ZEBIL',
  //         ]
  //       },
  //       SetOptions(merge: true)
  //     );
  //   });
  // });
}