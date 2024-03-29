import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transportation_app/config/config.dart';
import 'dart:math' as math;
import 'package:transportation_app/screens/ticket/ticket_provider.dart';

import 'components/passenger_data_form.dart';

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TicketPageProvider>();
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
            Text("Bilet #${ticket.id}"),
            //Text("", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 16 ),)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "trip",
        elevation: 0,
        backgroundColor: !ticket.cancelled ? Theme.of(context).colorScheme.secondary : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: !ticket.cancelled
        ? () async{
          var cancel = false;
          await showCupertinoDialog(
            context: context,
            barrierDismissible: true, 
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              titleTextStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
              title: Center(
                child: Container(
                  child: Text("Sunteți sigur că vreți să anulați biletul?", textAlign: TextAlign.center,),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  child: Text(
                    "Anulează"
                  ),
                  onPressed: () {
                    cancel = true;
                    Navigator.pop(context);
                  }
                ),
              ],
          ));
          if(cancel){
            await provider.cancelTicket(context);
          }
          else{
            // Navigator.pop(context);
          }
          // wrapperHomePageProvider.paymentPageProvider = PaymentPageProvider();
          // wrapperHomePageProvider.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        : null, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            !ticket.cancelled ? "Anulează bilet" : "Anulat",
            //"Plătește ${removeDecimalZeroFormat(ticket.price*provider.selectedPassengerNumber)}RON",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Container(
              //   child: Text("Pleacă din", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),),
              // ),
              SizedBox(height: 10),
              Container(
                child: Text.rich(
                  TextSpan( 
                   children: [
                      TextSpan(text: "${ticket.departureLocationName}", style: Theme.of(context).textTheme.headline3),
                      WidgetSpan(child: SizedBox(width: 20,)),
                      TextSpan(text: "(plecare)", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic)),
                    ]
                  )
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Text("${formatDateToWeekdayAndDate(ticket.departureTime)}", style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor)),
              ),
              Container(
                child: Text("${formatDateToHourAndMinutes(ticket.departureTime)}", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 22, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10),
              Align( /// three lines
                alignment: Alignment(-1,0),
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical : 5.0),
                  child: Container(
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: Image.asset(localAsset("three-lines"), height: 30, color: Theme.of(context).primaryColor,)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Text("${formatDateToHourAndMinutes(ticket.arrivalTime)}", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 22, fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Text("${formatDateToWeekdayAndDate(ticket.departureTime)}", style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor)),
              ),
              SizedBox(height: 10,),
              // Container(
              //   child: Text("Ajunge în", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),),
              // ),
              // Container(
              //   child: Text("${ticket.arrivalLocationName}", style: Theme.of(context).textTheme.headline3),
              // ),
              Container(
                child: Text.rich(
                  TextSpan( 
                   children: [
                      TextSpan(text: "${ticket.arrivalLocationName}", style: Theme.of(context).textTheme.headline3),
                      WidgetSpan(child: SizedBox(width: 20,)),
                      TextSpan(text: "(destinație)", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic)),
                    ]
                  )
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(MediaQuery.of(context).size.width ~/ 15, (index) => Text(
                    "-", 
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
                      fontSize: 25
                    ),
                  ))
                ),
              ),
              SizedBox(height: 10),
              Column( /// Company
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Companie", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(localAsset('company'), width: 22, color: Theme.of(context).primaryColor,),
                      SizedBox(width: 20),
                      Text("${ticket.companyName}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 18) ,)
                    ],
                  )
                ]
              ),
              SizedBox(height: 20),
              Column( /// Passenger No
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Număr pasageri", 
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),
                        ),
                        WidgetSpan(child: SizedBox(width: 20,)),
                        WidgetSpan(
                          child: MaterialButton(
                            height: 0,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                              value: provider,
                              child: PassengerDataForm(),
                            ))),
                            child: Text(
                              "Vezi date pasageri", 
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                        
                      ]
                    )
                    
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(localAsset('passenger'), width: 20, color: Theme.of(context).primaryColor,),
                      SizedBox(width: 20),
                      Text("${ticket.passengersNo}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 18) ,)
                    ],
                  ),

                  SizedBox(height: 20,),
                  Text("Bagaje", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),),
                  SizedBox(height: 10),
                  Column( /// Luggages
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ticket.passengerData!.map(
                      (passenger) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              child: Stack(
                                children: [
                                  Icon(Icons.person, size: 20,color: Theme.of(context).primaryColor),
                                  Positioned(
                                    top: 0 ,
                                    right: 0,
                                    child: Text("${ticket.passengerData!.indexOf(passenger)+1}", style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor))
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            formatLuggage(context, passenger['luggage'], Theme.of(context).primaryColor),
                          ],
                        ),
                      )
                    ).toList(),
                  ),
                ]
              ),
              SizedBox(height: 20),
              Column( /// Payment Method
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metodă de plată", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(localAsset('payment-method'), width: 20, color: Theme.of(context).primaryColor,),
                      SizedBox(width: 20),
                      Text("${formatPaymentMethod(ticket.paymentMethod!)}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 18) ,)
                    ],
                  )
                ]
              ),
              SizedBox(height: 20),
              Column( /// Price
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(localAsset('price'), width: 22, color: Theme.of(context).primaryColor,),
                      SizedBox(width: 20),
                      Text("${removeDecimalZeroFormat(ticket.price*ticket.passengersNo!)}RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 18) ,)
                    ],
                  )
                ]
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 100),
                  child: QrImage(
                    data: ticket.id.toString(),
                    size: 200,
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // Column( /// Passenger data
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Date pasageri", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal,),),
              //     SizedBox(height: 10),
              //     Row(
              //       children: [
              //         Image.asset(localAsset('passenger-data'), width: 22, color: Theme.of(context).primaryColor,),
              //         SizedBox(width: 20),
              //         Text("${removeDecimalZeroFormat(ticket.price*ticket.passengersNo!)}RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 18) ,)
              //       ],
              //     )
              //   ]
              // ),


              // Container(
              //   //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.primary,
              //     borderRadius: BorderRadius.circular(10)
              //   ),
              //   height: 500,
              //   width: MediaQuery.of(context).size.width*0.8,
              //   child: Stack(
              //     children: [
              //       Column(
              //         children: [
              //           Container( /// top half
              //             height: 250,
              //             padding: EdgeInsets.symmetric(
              //               horizontal: 20, 
              //               vertical: 25
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Row( /// Company and price half
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(ticket.companyName, style: Theme.of(context).textTheme.headline4),
              //                     Text(removeDecimalZeroFormat(ticket.price) + "RON", style: Theme.of(context).textTheme.headline5),
              //                   ],
              //                 ),
              //                 Row(  /// Departure and arrival half
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   crossAxisAlignment: CrossAxisAlignment.end,
              //                   children: [
              //                     Column( /// Departure side
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                       children: [
              //                         Container( /// Departure location
              //                           width: MediaQuery.of(context).size.width*0.3,
              //                           child: Text(
              //                             ticket.departureLocationName,
              //                             style: Theme.of(context).textTheme.headline6,
              //                           ),
              //                         ),
              //                         SizedBox(height: 5,),
              //                         Container( /// Departure time
              //                           //width: MediaQuery.of(context).size.width*0.3,
              //                           child: Row(
              //                             children: [
              //                               Image.asset(localAsset("time"), width: 18, color: Theme.of(context).colorScheme.secondary,),
              //                               SizedBox(width: 7,),
              //                               Text(
              //                                 formatDateToHourAndMinutes(ticket.departureTime)!,
              //                                 style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 21),
              //                               ),
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                     Column(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Icon(Icons.arrow_forward, color: Theme.of(context).canvasColor,),

              //                         Text( /// Travel time
              //                           formatDurationToHoursAndMinutes(ticket.arrivalTime.difference(ticket.departureTime)),
              //                           style: Theme.of(context).textTheme.subtitle2,
              //                         ),
              //                       ],
              //                     ), 
              //                     Column( /// Arrival side
              //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                       crossAxisAlignment: CrossAxisAlignment.end,
              //                       children: [
              //                         Container( /// Arrival location
              //                           width: MediaQuery.of(context).size.width*0.3,
              //                           child: Text(
              //                             ticket.arrivalLocationName,
              //                             style: Theme.of(context).textTheme.headline6,
              //                             textAlign: TextAlign.end,
              //                           ),
              //                         ),
              //                         SizedBox(height: 5,),
              //                         Container( /// Arrival time
              //                           //width: MediaQuery.of(context).size.width*0.3,
              //                           child: Row(
              //                             children: [
              //                               Image.asset(localAsset("time"), width: 18, color: Theme.of(context).colorScheme.secondary,),
              //                               SizedBox(width: 7,),
              //                               Text(
              //                                 formatDateToHourAndMinutes(ticket.arrivalTime)!,
              //                                 style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 21),
              //                               ),
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Container( /// bottom half
              //             height: 250,
              //             child: Column(
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              //                   child: Row(
              //                     children: [
              //                       Text.rich(
              //                         TextSpan(
              //                           children: [
              //                             WidgetSpan(child: SizedBox()),
              //                             TextSpan(text: "Nu ai cont?", style: Theme.of(context).textTheme.headline6),
              //                           ],
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             )
              //           )
              //         ],
              //       ),
              //       Positioned(
              //         top: 235,
              //         child: Container(
              //           width: MediaQuery.of(context).size.width,
              //           child: Row( /// Row of lines
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: List.generate(MediaQuery.of(context).size.width ~/ 15, (index) => Text(
              //               "-", 
              //               style: Theme.of(context).textTheme.headline6!.copyWith(
              //                 color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.5),
              //                 fontSize: 25
              //               ),
              //             ))
              //           ),
              //         ),
              //       ),
              //       Positioned( /// Left space
              //       left: 0,
              //       top: 235,
              //       child: Container(
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).canvasColor,
              //           borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
              //         ),
              //         width: 15,
              //       ),
              //     ),
              //     Positioned( /// Right space
              //       right: 0,
              //       top: 235,
              //       child: Container(
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).canvasColor,
              //           borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
              //         ),
              //         width: 15,
              //       ),
              //     ),
              //     ],
              //   ),
              // ),

            ],
          ),
          provider.isLoading
          ? Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
            ),
          )
          : Container(),
        ],
      ),
    );
  }
}