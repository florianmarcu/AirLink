import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/arrival_trips/arrival_trips_page.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/private_arrival_trips/private_arrival_trips_page.dart';
import 'package:transportation_app/screens/private_arrival_trips/private_arrival_trips_provider.dart';
import 'package:transportation_app/screens/private_trips/private_trips_provider.dart';
import 'package:transportation_app/screens/trip/trip_page.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

import 'components/empty_list.dart';


/// Page in which the user selects the desired private transportation type/vehicle (Volkswagen/Mercedes)
class PrivateTripsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var homeProvider = context.watch<HomePageProvider>();
    var provider = context.watch<PrivateTripsPageProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          // onPressed: () => wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn),
        ),
        toolbarHeight: 90,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alege tipul călătoriei dus"),
            SizedBox(height: 5),
            Text.rich(TextSpan(children: [
              WidgetSpan(child: Icon(Icons.calendar_today, size: 16,),),
              WidgetSpan(child: SizedBox(width: 10,)),
              TextSpan(
                text: "${formatDateToWeekdayAndDate(homeProvider.selectedDepartureDateAndHour)}",
                style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 )
              )
            ])),
            Text.rich(TextSpan(children: [
              WidgetSpan(child: Icon(Icons.access_time, size: 16,),),
              WidgetSpan(child: SizedBox(width: 10,)),
              TextSpan(
                text: "${formatDateToHourAndMinutes(homeProvider.selectedDepartureDateAndHour)}",
                style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 )
              )
            ])),
            // Text("${formatDateToWeekdayAndDate(homeProvider.selectedDepartureDateAndHour)}", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 ),),
            // Text("${formatDateToHourAndMinutes(homeProvider.selectedDepartureDateAndHour)}", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 ),),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: provider.tickets.length > 0 ? provider.tickets.length : 1,
            itemBuilder: (context, index) {
              if(!provider.isLoading)
                if(provider.tickets.length == 0)
                  return EmptyList();
                else {
                  var ticket = provider.tickets[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secAnimation) => !homeProvider.roundTrip
                        ? MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (context) => TripPageProvider(ticket),),
                            ChangeNotifierProvider<HomePageProvider>.value(value: homeProvider),
                            ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                          ],
                          child: TripPage()
                        )
                        : MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (context) => PrivateArrivalTripsPageProvider(homeProvider, ticket),),
                            ChangeNotifierProvider.value(value: wrapperHomePageProvider),
                            ChangeNotifierProvider<HomePageProvider>.value(value: homeProvider),
                          ],
                          child: PrivateArrivalTripsPage()
                        ),
                        transitionDuration: Duration(milliseconds: 300),
                        transitionsBuilder: (context, animation, secAnimation, child){
                          var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                          return SlideTransition(
                            child: child,
                            position: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0)
                            ).animate(_animation),
                          );
                        },
                    ));
                      // wrapperHomePageProvider.tripPageProvider = TripPageProvider(ticket);
                      // !homeProvider.roundTrip 
                      // ? wrapperHomePageProvider.pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn)
                      // : wrapperHomePageProvider.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                      
                      // !homeProvider.roundTrip
                      // ? Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => MultiProvider(
                      //     providers: [
                      //       ChangeNotifierProvider(create: (context) => TripPageProvider(ticket),),
                      //       ChangeNotifierProvider<HomePageProvider>.value(value: homeProvider),
                      //       ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                      //     ],
                      //     child: TripPage()
                      //   )
                      // ))
                      // : Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => MultiProvider(
                      //     providers: [
                      //       ChangeNotifierProvider(create: (context) => ArrivalTripsPageProvider(homeProvider, ticket),),
                      //       ChangeNotifierProvider.value(value: wrapperHomePageProvider),
                      //       ChangeNotifierProvider<HomePageProvider>.value(value: homeProvider),
                      //     ],
                      //     child: ArrivalTripsPage()
                      //   )
                      // ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // color: Theme.of(context).colorScheme.primary,
                          // borderRadius: BorderRadius.circular(10)
                        ),
                        height: 270,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Stack(
                          children: [
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 160,
                                  child: Row( // upper half
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container( /// Company and price half
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(localAsset("company"), width: 16, color: Theme.of(context).primaryColor,),
                                                SizedBox(width: 5,),
                                                Text(ticket.companyName, style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).primaryColor)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(localAsset("price"), width: 16, color: Theme.of(context).primaryColor,),
                                                SizedBox(width: 5,),
                                                Text(removeDecimalZeroFormat(ticket.price) + "RON", style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(localAsset("passenger"), width: 16, color: Theme.of(context).primaryColor,),
                                                SizedBox(width: 5,),
                                                Text(ticket.capacity.toString(), style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(localAsset("private"), width: 16, color: Theme.of(context).primaryColor,),
                                                SizedBox(width: 5,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: ticket.types!.map((type) => 
                                                    Text(type, style: Theme.of(context).textTheme.overline!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),)
                                                  .toList(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container( /// Image half
                                        width: MediaQuery.of(context).size.width*0.8/2,
                                        child: Image.network(
                                          ticket.photoURL!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Row( /// Company and price half
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(ticket.companyName, style: Theme.of(context).textTheme.headline4),
                                //     Text(removeDecimalZeroFormat(ticket.price) + "RON", style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                                //   ],
                                // ),
                                Container( // Information half
                                  height: 110,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  color: Theme.of(context).primaryColor,
                                  child: Row(  /// Departure and arrival half
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column( /// Departure side
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container( /// Departure location
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: Text(
                                              homeProvider.selectedDepartureLocation,
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
                                      Column( /// Travel time
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.arrow_forward, color: Theme.of(context).canvasColor,),

                                          Text( 
                                            formatDurationToHoursAndMinutes(ticket.arrivalTime.difference(ticket.departureTime)),
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                        ],
                                      ), 
                                      Column( /// Arrival side
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container( /// Arrival location
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: Text(
                                              homeProvider.selectedArrivalLocation,
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
                                ),
                              ],
                            ),
                            // Positioned(
                            //   top: 98,
                            //   child: Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     child: Row( /// Row of lines
                            //       mainAxisSize: MainAxisSize.max,
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: List.generate(MediaQuery.of(context).size.width ~/ 14, (index) => Text("-", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 34, color: Theme.of(context).canvasColor)))
                            //     ),
                            //   ),
                            // ),
                            Positioned( /// Left space
                            left: 0,
                            top: 145,
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
                              top: 145,
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
                    ),
                  );
                }
              else return Container();
            } 
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