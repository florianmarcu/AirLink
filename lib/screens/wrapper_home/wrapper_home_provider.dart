import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_page.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/payment/payment_provider.dart';
import 'package:transportation_app/screens/profile/profile_page.dart';
import 'package:transportation_app/screens/profile/profile_provider.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
import 'package:transportation_app/screens/tickets/tickets_page.dart';
import 'package:transportation_app/screens/tickets/tickets_provider.dart';
export 'package:provider/provider.dart';

class WrapperHomePageProvider with ChangeNotifier{
  BuildContext context;
  int selectedScreenIndex = 0;
  UserProfile? currentUser; 
  bool isLoading = false;
  List<Widget> screens = [];
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  PageController pageController = PageController();
  TripPageProvider? tripPageProvider;
  PaymentPageProvider? paymentPageProvider;


  List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Acasă",
      icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: "Bilete",
      icon: Icon(Icons.history)
    ),
    BottomNavigationBarItem(
      label: "Profil",
      icon: Icon(Icons.person)
    ),
  ];

  WrapperHomePageProvider(this.context){
    getData(context);
  }

  void rebuildTicketPageProvider(){
    // if(pageController.page == 3){ /// Workaround that solves the TicketPageProvider being disposed upon popping the Payment Page
    //   var oldProvider = ticketPageProvider!;
    //   ticketPageProvider = TicketPageProvider(ticketPageProvider!.ticket);
    //   ticketPageProvider!.passengerData = oldProvider.passengerData;
    //   ticketPageProvider!.selectedAirline = oldProvider.selectedAirline;
    //   ticketPageProvider!.selectedPassengerNumber = oldProvider.selectedPassengerNumber;
    // } 
  }

  Future<void> getData(BuildContext context) async{
    _loading();

    currentUser = await userToUserProfile(context.read<User?>());

    HomePageProvider homePageProvider = HomePageProvider();

    
    screens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>.value(  /// First screen - contains departure, arrival and date searching criteria
        value: homePageProvider,
        builder: (context, _) {
          return HomePage();
        }
      ), 
      // WillPopScope(
      //   onWillPop: () async{
      //     if(pageController.page == pageController.initialPage)  
      //       return true;
      //     else {
      //       rebuildTicketPageProvider();
      //       pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      //       return false;
      //     }
      //   },
      //   child: PageView( /// Page View that contains all the screens from ticket buying user flow
      //     physics: NeverScrollableScrollPhysics(),
      //     controller: pageController,
      //     children: [
      //       ChangeNotifierProvider<HomePageProvider>.value(  /// First screen - contains departure, arrival and date searching criteria
      //         value: homePageProvider,
      //         builder: (context, _) {
      //           return HomePage();
      //         }
      //       ), 
      //       MultiProvider( /// Second screen - contains the departures available from the selected data
      //         providers: [
      //           ChangeNotifierProvider<TripsPageProvider>(create: (_) => TripsPageProvider(homePageProvider)),
      //           ChangeNotifierProvider<HomePageProvider>.value(value: homePageProvider)
      //         ],
      //         child: TripsPage()
      //       ),
      //       MultiProvider( /// (AVAILABLE ONLY FOR ROUNDTRIPS) Second screen - contains the arrivals available from the selected data
      //         providers: [
      //           ChangeNotifierProvider<ArrivalTripsPageProvider>(create: (_) => ArrivalTripsPageProvider(homePageProvider)),
      //           ChangeNotifierProvider<HomePageProvider>.value(value: homePageProvider)
      //         ],
      //         child: ArrivalTripsPage()
      //       ),
      //       ChangeNotifierProvider<TripPageProvider?>( /// Third screen - contains the ticket and passenger form
      //         create: (_) => tripPageProvider,
      //         builder: (context, _) {
      //           return TripPage();
      //         }
      //       ),
      //       MultiProvider( /// Fourth screen - payment screen
      //         providers: [
      //           ChangeNotifierProvider<TripPageProvider?>(
      //             create: (_) => tripPageProvider,
      //           ),
      //           ChangeNotifierProvider<PaymentPageProvider?>( 
      //             create: (_) => paymentPageProvider,
      //           ),
      //         ],
      //         child: PaymentPage(),
      //       ),
      //     ],
      //   ),
      // ),
      ChangeNotifierProvider<TicketsPageProvider>(
        create: (context) => TicketsPageProvider(),
        builder: (context, _) {
          return TicketsPage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];

    _loading();

    notifyListeners();
  }

  void updateSelectedScreenIndex(int index){
    /// If the user is anonymous, do not allow to see the Profile page
    if(Authentication.auth.currentUser!.isAnonymous && index == 2)
      showCupertinoDialog(
        context: context,
        barrierDismissible: true, 
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
          title: Center(
            child: Container(
              child: Text("Pentru a vizualiza profilul, trebuie să fiți logat.", textAlign: TextAlign.center,),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              child: Text(
                "Log In"
              ),
              onPressed: () {
                Navigator.pop(context);
                Authentication.signOut();
              }
            ),
          ],
      ));
    else selectedScreenIndex = index;

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}