import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/arrival_trip/arrival_trip_page.dart';
import 'package:transportation_app/screens/arrival_trip/arrival_trip_provider.dart';
import 'package:transportation_app/screens/cupertino_date_picker/cupertino_date_picker_page.dart';
import 'package:transportation_app/screens/cupertino_hour_picker/cupertino_hour_picker_page.dart';
import 'package:transportation_app/screens/date_and_hour_picker/date_and_hour_picker_page.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/payment/payment_page.dart';
import 'package:transportation_app/screens/payment/payment_provider.dart';
import 'package:transportation_app/screens/trip/components/passenger_data_form.dart';
import 'package:transportation_app/screens/trip/components/trip_destinations.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class TripPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<TripPageProvider?>();
    var homePageProvider = context.watch<HomePageProvider>();
    var ticket = provider!.ticket;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          // onPressed: () => wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.arrow_back_ios),
            //child: Image.asset(localAsset("cancel"),),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        // title: Row(
        //   children: [
        //     Column(
        //       children: [
        //         Text(ticket.departureLocationName)
        //       ],
        //     )
        //   ],
        // )
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Text(
          !homePageProvider.roundTrip
          ? "Detalii călătorie"
          : "Detalii călătorie dus"
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "ticket",
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: (){
          if(provider.isPassengerFormFieldComplete) {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secAnimation) => !homePageProvider.roundTrip
              ? MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => PaymentPageProvider(wrapperHomePageProvider.currentUser, homePageProvider, ticket, provider, null, null)),
                  ChangeNotifierProvider.value(value: wrapperHomePageProvider,),
                  ChangeNotifierProvider.value(value: provider),
                  ChangeNotifierProvider.value(value: homePageProvider,),
                ],
                child: PaymentPage(),
              )
              : MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => ArrivalTripPageProvider(ticket, provider, returnTicket: provider.returnTicket!)),
                  ChangeNotifierProvider.value(value: wrapperHomePageProvider,),
                  ChangeNotifierProvider.value(value: homePageProvider),
                  ChangeNotifierProvider.value(value: provider)
                ],
                child: ArrivalTripPage(),
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
            // !homeProvider.roundTrip
            // ? Navigator.push(context, MaterialPageRoute(builder: (context) => MultiProvider(
            //   providers: [
            //     ChangeNotifierProvider(create: (_) => PaymentPageProvider()),
            //     ChangeNotifierProvider.value(value: wrapperHomePageProvider,),
            //     ChangeNotifierProvider.value(value: provider)
            //   ],
            //   child: PaymentPage(),
            // ),))
            // : Navigator.push(context, MaterialPageRoute(builder: (context) => MultiProvider(
            //   providers: [
            //     ChangeNotifierProvider(create: (_) => ArrivalTripPageProvider(ticket, provider, returnTicket: provider.returnTicket!)),
            //     ChangeNotifierProvider.value(value: wrapperHomePageProvider,),
            //     ChangeNotifierProvider.value(value: homeProvider),
            //     ChangeNotifierProvider.value(value: provider)
            //   ],
            //   child: ArrivalTripPage(),
            // ),));
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text.rich(TextSpan( children: [
                WidgetSpan(child: Icon(Icons.info, color: Theme.of(context).canvasColor, size: 17,)),
                WidgetSpan(child: SizedBox(width: 10,)),
                TextSpan(text: "Trebuie să completați datele pasagerilor")
              ])))
            );
          }
          // wrapperHomePageProvider.paymentPageProvider = PaymentPageProvider();
          // wrapperHomePageProvider.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            "Continuă",
            //"Plătește ${removeDecimalZeroFormat(ticket.price*provider.selectedPassengerNumber)}RON",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 5),
        children: [
          Padding( /// hours and lines
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
              height: 220,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container( /// departure location
                              //padding: EdgeInsets.symmetric(10),
                              child: Text( 
                                ticket.departureLocationName,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height*0.01),
                            Container( /// departure date
                              //padding: EdgeInsets.symmetric(10),
                              child: Text( 
                                formatDateToWeekdayAndDate(ticket.departureTime),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Padding( /// hours and lines
                              padding: EdgeInsets.symmetric(vertical: 0.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      formatDateToHourAndMinutes(ticket.departureTime)!,
                                      style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(vertical : 10.0),
                                    //   child: ListView.builder(
                                    //     shrinkWrap: true,
                                    //     itemCount: 3,
                                    //     itemBuilder: (context, index) => Transform.rotate(
                                    //       angle: math.pi/2,
                                    //       child: Text(
                                    //         "-", 
                                    //         style: Theme.of(context).textTheme.labelMedium,
                                    //     ))
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical : 5.0),
                                      child: Container(
                                        child: Transform.rotate(
                                          angle: math.pi / 2,
                                          child: Image.asset(localAsset("three-lines"), height: 30, color: Theme.of(context).canvasColor,)
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatDateToHourAndMinutes(ticket.arrivalTime)!,
                                      style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container( /// arrival date
                              //padding: EdgeInsets.symmetric(10),
                              child: Text( 
                                formatDateToWeekdayAndDate(ticket.arrivalTime),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height*0.01),
                            Text( /// arrival location
                              ticket.arrivalLocationName,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical : 10.0),
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: 3,
                      //     itemBuilder: (context, index) => Transform.rotate(
                      //       angle: math.pi/2,
                      //       child: Text(
                      //         "-", 
                      //         style: Theme.of(context).textTheme.labelMedium,
                      //     ))
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical : 5.0),
                      //   child: Container(
                      //     child: Transform.rotate(
                      //       angle: math.pi / 2,
                      //       child: Image.asset(localAsset("three-lines"), height: 30, color: Theme.of(context).canvasColor,)
                      //     ),
                      //   ),
                      // ),
                      // Text(
                      //   formatDateToHourAndMinutes(ticket.arrivalTime)!,
                      //   style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
                      // ),
                    ],
                  ),
                  Positioned( /// Left space
                    left: 0,
                    top: 100,
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
                    top: 100,
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
          SizedBox( height: 20,),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: TripDestinationsPage(),
                )
              )),
              child: Text("Destinații intermediare", style: Theme.of(context).textTheme.bodyMedium!.copyWith( decoration: TextDecoration.underline),),
            ),
          ),
          SizedBox( height: 20,),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Text( 
          //     "Detalii călătorie",
          //     style: Theme.of(context).textTheme.headline3,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              //height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // color: Colors.red
                color: Theme.of(context).colorScheme.primary
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text.rich( /// passengers no
                  //       TextSpan(
                  //         children: [
                  //           WidgetSpan(child: Image.asset(localAsset('passenger'), width: 18, color: Theme.of(context).canvasColor,),),
                  //           WidgetSpan(child: SizedBox(width: 20)),
                  //           TextSpan(
                  //             text: "Număr pasageri",
                  //             style: Theme.of(context).textTheme.headline6!.copyWith(
                  //               // color: Theme.of(context).primaryColor
                  //             )
                  //           ),
                  //           // WidgetSpan(
                  //           //   child: DropdownButton(
                  //           //     underline: Container(),
                  //           //     style: Theme.of(context).textTheme.overline,
                  //           //     items: provider.passengerNumberList.map(
                  //           //       (number) => DropdownMenuItem(
                  //           //         value: number,
                  //           //         child: Text("$number")
                  //           //       )
                  //           //     ).toList(), 
                  //           //     value: provider.selectedPassengerNumber,
                  //           //     onChanged: provider.updateSelectedPassengerNumber
                  //           //   )
                  //           // )
                  //         ]
                  //       )
                  //     ),
                  //     Expanded(child: Container(),),
                      
                  //   ],
                  // ),
                  Text("Număr pasageri", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),),
                  Row(
                    children: [
                      Image.asset(localAsset('passenger'), width: 20, color: Theme.of(context).canvasColor,),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width*0.65,
                        child: DropdownButton( /// passenger no dropdownbutton
                          // decoration: InputDecoration(
                          //   prefixIconConstraints: BoxConstraints(maxWidth: 50),
                          //   prefixIcon: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          //     child: Image.asset(localAsset('passenger'), width: 18, color: Theme.of(context).canvasColor,),
                          //   ),
                          //   labelStyle: Theme.of(context).textTheme.subtitle2,
                          //   labelText: "Număr pasageri",
                          // ),
                          underline: Container(),
                          iconEnabledColor: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(30),
                          style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).canvasColor, fontSize: 18),
                          dropdownColor: Theme.of(context).primaryColor,
                          items: provider.passengerNumberList.map(
                            (number) => DropdownMenuItem(
                              value: number,
                              child: Text("${number}")
                            )
                          ).toList(), 
                          isExpanded: true,
                          //hint: Text("Număr pasageri"),
                          value: provider.selectedPassengerNumber,
                          onChanged: provider.updateSelectedPassengerNumber
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding( /// passenger data form button
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextButton(
                          style: Theme.of(context).textButtonTheme.style!.copyWith(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                            overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).splashColor.withOpacity(0.3)),
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                            value: provider,
                            child: PassengerDataForm(),
                          ))).then((value) {
                            print(provider.phoneNumberFormKeys[0].currentState.toString() + " stare");
                            provider.updatePassengerFormFieldComplete();
                          }),
                          child: Text("Completează datele", style: Theme.of(context).textTheme.caption!.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).canvasColor
                            //color: Color(0xFF393E46)
                          ),),
                        ),
                      ),
                      SizedBox(width: 10,),
                      !provider.isPassengerFormFieldComplete
                      ? Image.asset(localAsset("cancel"), width: 12, color: Theme.of(context).canvasColor)
                      : Image.asset(localAsset("check"), width: 12, color: Theme.of(context).canvasColor)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: provider.passengerData.map(
                      (passenger) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              child: Stack(
                                children: [
                                  Icon(Icons.person, size: 22,color: Theme.of(context).canvasColor),
                                  Positioned(
                                    top: 0 ,
                                    right: 0,
                                    child: Text("${provider.passengerData.indexOf(passenger)+1}", style: Theme.of(context).textTheme.headline6)
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(width: 10,),
                            formatLuggage(context, passenger['luggage'], Theme.of(context).canvasColor)
                          ],
                        ),
                      )
                    ).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Am nevoie de scaun pentru copil", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),),
                      SizedBox(width: 30,),
                      Checkbox(
                        value: provider.needChildrenSeat, 
                        onChanged: provider.updateNeedChildrenSeat,
                        fillColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                        checkColor: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Companie aeriană", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),),
                  Row(
                    children: [
                      Image.asset(localAsset('airline'), width: 20, color: Theme.of(context).canvasColor,),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width*0.65,
                        child: DropdownButton( /// airlines dropdownbutton
                          // decoration: InputDecoration(
                          //   prefixIconConstraints: BoxConstraints(maxWidth: 50),
                          //   prefixIcon: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          //     child: Image.asset(localAsset('passenger'), width: 18, color: Theme.of(context).canvasColor,),
                          //   ),
                          //   labelStyle: Theme.of(context).textTheme.subtitle2,
                          //   labelText: "Număr pasageri",
                          // ),
                          underline: Container(),
                          iconEnabledColor: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(30),
                          style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).canvasColor, fontSize: 18),
                          dropdownColor: Theme.of(context).primaryColor,
                          items: provider.airlineList.map(
                            (number) => DropdownMenuItem(
                              value: number,
                              child: Text("${number}")
                            )
                          ).toList(), 
                          isExpanded: true,
                          //hint: Text("Număr pasageri"),
                          value: provider.selectedAirline,
                          onChanged: provider.updateSelectedAirline
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Data zborului", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset(localAsset('flight-date'), width: 23, color: Theme.of(context).canvasColor,),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          !Platform.isIOS
                          ? Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: provider,
                              child: DateAndHourPickerPage(),
                            )
                          ))
                          : showModalBottomSheet(
                            context: context, 
                            builder: (context) => ChangeNotifierProvider.value(
                              value: provider,
                              child: CupertinoDatePickerPage()
                            )
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.65,
                          child: DropdownButton<DateTime>( /// flight date dropdownbutton
                            // decoration: InputDecoration(
                            //   prefixIconConstraints: BoxConstraints(maxWidth: 50),
                            //   prefixIcon: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            //     child: Image.asset(localAsset('passenger'), width: 18, color: Theme.of(context).canvasColor,),
                            //   ),
                            //   labelStyle: Theme.of(context).textTheme.subtitle2,
                            //   labelText: "Număr pasageri",
                            // ),
                            underline: Container(),
                            iconEnabledColor: Theme.of(context).canvasColor,
                            iconDisabledColor: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(30),
                            style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).canvasColor, fontSize: 18),
                            dropdownColor: Theme.of(context).primaryColor,
                            items: [],
                            isExpanded: true,
                            hint: Text(
                              "${formatDateToWeekdayAndDate(provider.selectedDepartureDateAndHour)}", 
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            value: provider.selectedDepartureDateAndHour,
                            onChanged: (date) => provider.updateSelectedDepartureDateAndHour(date!),
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Ora zborului", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset(localAsset('time'), width: 23, color: Theme.of(context).canvasColor,),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async{
                          if(!Platform.isIOS){
                            var time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(provider.selectedDepartureDateAndHour)
                            );
                            provider.updateSelectedDepartureHourAndroid(time);
                          }
                          else{
                            showModalBottomSheet(
                              context: context, 
                              builder: (context) => ChangeNotifierProvider.value(
                                value: provider,
                                child: CupertinoHourPickerPage()
                              )
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.65,
                          child: DropdownButton<DateTime>( /// flight hour dropdownbutton
                            // decoration: InputDecoration(
                            //   prefixIconConstraints: BoxConstraints(maxWidth: 50),
                            //   prefixIcon: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            //     child: Image.asset(localAsset('passenger'), width: 18, color: Theme.of(context).canvasColor,),
                            //   ),
                            //   labelStyle: Theme.of(context).textTheme.subtitle2,
                            //   labelText: "Număr pasageri",
                            // ),
                            underline: Container(),
                            iconEnabledColor: Theme.of(context).canvasColor,
                            iconDisabledColor: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(30),
                            style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).canvasColor, fontSize: 18),
                            dropdownColor: Theme.of(context).primaryColor,
                            items: [],
                            isExpanded: true,
                            hint: Text(
                              "${formatDateToHourAndMinutes(provider.selectedDepartureDateAndHour)}",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            value: provider.selectedDepartureDateAndHour,
                            onChanged: (date) => provider.updateSelectedDepartureDateAndHour(date!),
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }
}


// Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             color: Theme.of(context).colorScheme.primary,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   //padding: EdgeInsets.symmetric(10),
//                   child: Text( /// departure location
//                     ticket.departureLocationName,
//                     style: Theme.of(context).textTheme.headline5,
//                   ),
//                 ),
//                 Padding( /// hours and lines
//                   padding: EdgeInsets.symmetric(vertical: 5.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Column(
//                       children: [
//                         Text(
//                           formatDateToHourAndMinutes(ticket.departureTime)!,
//                           style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
//                         ),
//                         // Padding(
//                         //   padding: EdgeInsets.symmetric(vertical : 10.0),
//                         //   child: ListView.builder(
//                         //     shrinkWrap: true,
//                         //     itemCount: 3,
//                         //     itemBuilder: (context, index) => Transform.rotate(
//                         //       angle: math.pi/2,
//                         //       child: Text(
//                         //         "-", 
//                         //         style: Theme.of(context).textTheme.labelMedium,
//                         //     ))
//                         //   ),
//                         // ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical : 5.0),
//                           child: Container(
//                             child: Transform.rotate(
//                               angle: math.pi / 2,
//                               child: Image.asset(localAsset("three-lines"), height: 30, color: Theme.of(context).canvasColor,)
//                             ),
//                           ),
//                         ),
//                         Text(
//                           formatDateToHourAndMinutes(ticket.arrivalTime)!,
//                           style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Text( /// arrival location
//                   ticket.arrivalLocationName,
//                   style: Theme.of(context).textTheme.headline5,
//                 ),
//               ],
//             ),
//           ),

// Container(
                //   padding: EdgeInsets.only(right: 10, left: 10,  top: 10, bottom: 30),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary,
                //     borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Container( /// departure location
                //         width: MediaQuery.of(context).size.width,
                //         child: Text( 
                //           ticket.departureLocationName,
                //           style: Theme.of(context).textTheme.headline5,
                //         ),
                //       ),
                //       Text( /// departure hour
                //         formatDateToHourAndMinutes(ticket.departureTime)!,
                //         style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
                //       ),
                //     ],
                //   ),
                // ),
                // Container( /// Weird border bottom
                //   width: MediaQuery.of(context).size.width,
                //   height: 30,
                //   decoration: ShapeDecoration(
                //     shape: WeirdBottomBorder(radius: 15),
                //     color: Theme.of(context).colorScheme.primary
                //   ),
                // ),
                // Container( /// Weird border top
                //   width: MediaQuery.of(context).size.width,
                //   height: 30,
                //   decoration: ShapeDecoration(
                //     shape: WeirdTopBorder(radius: 15),
                //     color: Theme.of(context).colorScheme.primary
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.only(right: 10, left: 10,  top: 10, bottom: 30),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary,
                //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text( /// arrival hour
                //         formatDateToHourAndMinutes(ticket.arrivalTime)!,
                //         style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
                //       ),
                //       Container( /// arrival location
                //         width: MediaQuery.of(context).size.width,
                //         child: Text( 
                //           ticket.arrivalLocationName,
                //           style: Theme.of(context).textTheme.headline5,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),