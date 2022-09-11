import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';

class TripPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TripPageProvider>();
    var ticket = provider.ticket;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alege plecarea"),
            //Text("", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 ),)
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10)
            ),
            height: 500,
            width: MediaQuery.of(context).size.width*0.8,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container( /// top half
                      height: 250,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20, 
                        vertical: 25
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row( /// Company and price half
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ticket.companyName, style: Theme.of(context).textTheme.headline4),
                              Text(removeDecimalZeroFormat(ticket.price) + "RON", style: Theme.of(context).textTheme.headline5),
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
                                      ticket.departureLocationName,
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
                                      ticket.arrivalLocationName,
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
                    Container( /// bottom half
                      height: 250,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(child: SizedBox()),
                                      TextSpan(text: "Nu ai cont?", style: Theme.of(context).textTheme.headline6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
                Positioned(
                  top: 235,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row( /// Row of lines
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(MediaQuery.of(context).size.width ~/ 15, (index) => Text(
                        "-", 
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.5),
                          fontSize: 25
                        ),
                      ))
                    ),
                  ),
                ),
                Positioned( /// Left space
                left: 0,
                top: 235,
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
                top: 235,
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
        ],
      ),
    );
  }
}