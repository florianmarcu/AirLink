import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/ticket/ticket_page.dart';
import 'package:transportation_app/screens/ticket/ticket_provider.dart';
import 'package:transportation_app/screens/tickets/components/empty_list.dart';
import 'package:transportation_app/screens/tickets/tickets_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<TicketsPageProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              onPressed: () => wrapperHomePageProvider.key.currentState!.openDrawer(),
              icon: Icon(Icons.menu, size: 30,)
            ),
          )
        ],
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                wrapperHomePageProvider
                    .screenLabels[wrapperHomePageProvider.selectedScreenIndex]
                    .label!,
              )),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await provider.getData();
        },
        child: Stack(
          children: [
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              itemCount: provider.tickets == null ? 1 : provider.tickets!.length,
              separatorBuilder: (context, index) => SizedBox(height: 15,),
              itemBuilder: (context, index){
                var tickets = provider.tickets;
                if(tickets == null || tickets.length == 0){
                  return EmptyList();
                }
                else {
                  var ticket = tickets[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        transitionsBuilder: (context, animation, secAnimation, child){
                          var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                          return SlideTransition(
                            child: child,
                            position: Tween<Offset>(
                              begin: Offset(1,0),
                              end: Offset(0,0)
                            ).animate(_animation),
                          );
                        },
                        pageBuilder: (context, animation, secAnimation){
                          return ChangeNotifierProvider(
                            create: (_) => TicketPageProvider(ticket),
                            child: TicketPage()
                          );
                        }
                      ));
                    },
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      height: 360,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Stack(
                        children: [
                          Container(
                            height: 360,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container( /// upper half
                                  height: 180,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15, 
                                    // vertical: 10
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text.rich( /// Ticket's status
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: ticket.status == TicketStatus.upcoming ? "Urmează" : "Trecut", 
                                              style: Theme.of(context).textTheme.subtitle2
                                            ),
                                            WidgetSpan(child: SizedBox(width: 7)),
                                            WidgetSpan(
                                              child: Icon(
                                                ticket.status == TicketStatus.upcoming ? Icons.access_time_rounded : Icons.check, 
                                                size: 15, 
                                                color: Theme.of(context).canvasColor
                                              )
                                            ),
                                          ] 
                                        ),
                                      ),
                                      Row( /// Departure and arrival half
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column( /// Departure side
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container( /// Departure location
                                                  // width: MediaQuery.of(context).size.width*0.3,
                                                  child: Text(
                                                    ticket.departureLocationName,
                                                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                // SizedBox(height: 20,),
                                                Column( /// Departure date and time 
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container( /// Departure date
                                                      //width: MediaQuery.of(context).size.width*0.3,
                                                      child: Text(
                                                        formatDateToWeekdayAndShortDate(ticket.arrivalTime),
                                                        style: Theme.of(context).textTheme.subtitle2,
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
                                              ],
                                            ),
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
                                          Expanded(
                                            child: Column( /// Arrival side
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container( /// Arrival location
                                                  // width: MediaQuery.of(context).size.width*0.3,
                                                  child: Text(
                                                    ticket.arrivalLocationName,
                                                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                                // SizedBox(height: 15,),
                                                Column( /// Arrival date and time
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container( /// Arrival date
                                                      //width: MediaQuery.of(context).size.width*0.3,
                                                      child: Text(
                                                        formatDateToWeekdayAndShortDate(ticket.arrivalTime),
                                                        style: Theme.of(context).textTheme.subtitle2,
                                                        textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container( /// Arrival time
                                                      //width: MediaQuery.of(context).size.width*0.3,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
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
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container( /// lower half
                                  height: 180,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20, 
                                    vertical: 25
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Număr pasageri", style: Theme.of(context).textTheme.subtitle2,),
                                              SizedBox(height: 10,),
                                              Row( /// Passengers No
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Image.asset(localAsset("passenger"), width: 20, color: Theme.of(context).canvasColor,)),
                                                        WidgetSpan(child: SizedBox(width: 20,)),
                                                        TextSpan(text: "${ticket.passengersNo}", style: Theme.of(context).textTheme.headline6)
                                                      ]
                                                    )
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Metodă de plată", style: Theme.of(context).textTheme.subtitle2,),
                                              SizedBox(height: 10,),
                                              Row( /// Payment method
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Image.asset(localAsset("payment-method"), width: 20, color: Theme.of(context).canvasColor,)),
                                                        WidgetSpan(child: SizedBox(width: 20,)),
                                                        TextSpan(text: "${formatPaymentMethod(ticket.paymentMethod!)}", style: Theme.of(context).textTheme.headline6)
                                                      ]
                                                    )
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Companie", style: Theme.of(context).textTheme.subtitle2,),
                                              SizedBox(height: 10,),
                                              Row( /// Passengers No
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Image.asset(localAsset("company"), width: 20, color: Theme.of(context).canvasColor,)),
                                                        WidgetSpan(child: SizedBox(width: 20,)),
                                                        TextSpan(text: "${ticket.companyName}", style: Theme.of(context).textTheme.headline6)
                                                      ]
                                                    )
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Total", style: Theme.of(context).textTheme.subtitle2,),
                                              SizedBox(height: 10,),
                                              Row( /// Total
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Image.asset(localAsset("price"), width: 20, color: Theme.of(context).canvasColor,)),
                                                        WidgetSpan(child: SizedBox(width: 20,)),
                                                        // TextSpan(text: "${ticket.price}", style: Theme.of(context).textTheme.headline6)
                                                        TextSpan(text: removeDecimalZeroFormat(ticket.price * ticket.passengersNo!) + "RON", style: Theme.of(context).textTheme.headline6),

                                                      ]
                                                    )
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ticket.cancelled == true
                          ? Container( /// Cancelled status
                            height: 360,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Align(
                              alignment: Alignment(0, 0.9),
                              child: Text("Anulat", style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),)),
                          )
                          : Container(),
                          Positioned( /// Row of lines
                            top: 170,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row( 
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
                          top: 170,
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
                            top: 170,
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
              }, 
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
      ),
    );
  }
}