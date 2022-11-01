import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/trip/trip_page.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
import 'package:transportation_app/screens/arrival_trips/arrival_trips_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';
import 'components/empty_list.dart';
import 'components/filters_popup.dart';

class ArrivalTripsPage extends StatefulWidget {
  @override
  State<ArrivalTripsPage> createState() => _ArrivalTripsPageState();
}

class _ArrivalTripsPageState extends State<ArrivalTripsPage>{

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var homeProvider = context.watch<HomePageProvider>();
    var provider = context.watch<ArrivalTripsPageProvider>();
    //provider.getData();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Stack(
                children: [
                  Center(child: Image.asset(localAsset('filter'), width: 30,)),
                  provider.activeFilters['sorts']!.fold(false, (prev, curr) => prev || curr)
                  ? Positioned(
                    right: 0,
                    top: 12,
                    child: Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: new BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                  : Container()
                ]
                ,
              ),
              onPressed: (){
                showGeneralDialog(
                  context: context,
                  transitionDuration: Duration(milliseconds: 300),
                  transitionBuilder: (context, animation, secondAnimation, child){
                    var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                    return SlideTransition(
                      child: child,
                      position: Tween<Offset>(
                        begin: Offset(0,-1),
                        end: Offset(0,0)
                      ).animate(_animation),
                    );
                  },
                  pageBuilder: ((context, animation, secondaryAnimation) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: provider,),
                      // ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                    ],
                    child: FiltersPopUpPage()
                  )
                ));
              },
            )
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          // onPressed: () => wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn),
        ),
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alege întoarcerea"),
            Text("${formatDateToWeekdayAndDate(homeProvider.selectedArrivalDate)}", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 ),)
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: provider.tickets.length > 0 ? provider.tickets.length : 1,
              separatorBuilder: (context, index) => SizedBox(height: 30,),
              itemBuilder: (context, index) {
                if(!provider.isLoading)
                  if(provider.tickets.length == 0)
                    return EmptyList();
                  else {
                    var ticket = provider.tickets[index];
                    return GestureDetector(
                      onTap: (){
                        // wrapperHomePageProvider.tripPageProvider = TripPageProvider(ticket);
                        // homeProvider.roundTrip 
                        // ? wrapperHomePageProvider.pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn)
                        // : wrapperHomePageProvider.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (context) => TripPageProvider(provider.departureTicket, returnTicket: ticket),),
                              ChangeNotifierProvider.value(value: homeProvider),
                              ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                            ],
                            child: TripPage()
                          )
                        ));
                      },
                      child: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row( /// Company and price half
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ticket.companyName, style: Theme.of(context).textTheme.headline4),
                                      Text(removeDecimalZeroFormat(ticket.price) + "RON", style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(  /// Departure and arrival half
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column( /// Departure side
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container( /// Departure location
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: Text(
                                              homeProvider.selectedArrivalLocation,
                                              style: Theme.of(context).textTheme.headline6,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Container( /// Departure time
                                            //width: MediaQuery.of(context).size.width*0.3,
                                            child: Row(
                                              children: [
                                                Image.asset(localAsset("time"), width: 18, color: Theme.of(context).colorScheme.secondary,),
                                                SizedBox(width: 7,),
                                                Text(
                                                  formatDateToHourAndMinutes(ticket.departureTime)!,
                                                  style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 21),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.arrow_forward, color: Theme.of(context).canvasColor,),

                                          Text( /// Travel time
                                            formatDurationToHoursAndMinutes(ticket.arrivalTime.difference(ticket.departureTime)),
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                        ],
                                      ), 
                                      Column( /// Arrival side
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container( /// Arrival location
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: Text(
                                              homeProvider.selectedDepartureLocation,
                                              style: Theme.of(context).textTheme.headline6,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Container( /// Arrival time
                                            //width: MediaQuery.of(context).size.width*0.3,
                                            child: Row(
                                              children: [
                                                Image.asset(localAsset("time"), width: 18, color: Theme.of(context).colorScheme.secondary,),
                                                SizedBox(width: 7,),
                                                Text(
                                                  formatDateToHourAndMinutes(ticket.arrivalTime)!,
                                                  style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 21),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned( /// Left space
                            left: 0,
                            top: 85,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
                              ),
                              width: 15,
                            ),
                          ),
                          Positioned( /// Right space
                            right: 0,
                            top: 85,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
                              ),
                              width: 15,
                            ),
                          ),
                          ],
                        ),
                      ),
                    );
                  }
                else return Container();
              } 
            ),
          ),
          provider.isLoading
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
            ), 
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
        ],
      ),
    );
  }
}