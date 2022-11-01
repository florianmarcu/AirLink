import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/arrival_trip/arrival_trip_provider.dart';
import 'package:transportation_app/screens/payment/components/trip_details.dart';
import 'package:transportation_app/screens/payment/payment_provider.dart';
import 'package:transportation_app/screens/ticket/ticket_page.dart';
import 'package:transportation_app/screens/ticket/ticket_provider.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<PaymentPageProvider>();
    var tripPageProvider = context.watch<TripPageProvider>();
    var ticket = tripPageProvider.ticket;
    var returnTicket;
    ArrivalTripPageProvider? arrivalTripPageProvider;
    if(tripPageProvider.returnTicket != null) {
      arrivalTripPageProvider = context.watch<ArrivalTripPageProvider>();
      returnTicket = arrivalTripPageProvider.returnTicket;
    }
    print(tripPageProvider.passengerData.length);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
            // wrapperHomePageProvider.rebuildTicketPageProvider();
            // //wrapperHomePageProvider.ticketPageProvider = TicketPageProvider(ticketPageProvider.ticket);
            // wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.arrow_back_ios),
            //child: Image.asset(localAsset("cancel"),),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text("Finalizează"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "payment",
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: (){
          provider.makeReservation(ticket, returnTicket, tripPageProvider, arrivalTripPageProvider)
          .then((newTicket){
            Navigator.popUntil(context, (route) => route.isFirst);
            // wrapperHomePageProvider.pageController.jumpToPage(0);
            wrapperHomePageProvider.updateSelectedScreenIndex(1);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
              create: (_) => TicketPageProvider(newTicket),
              child: TicketPage(),
            )));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ticket.passengersNo == 1
                  ? "Confirmarea biletului dumneavoastră a fost trimisă pe email"
                  : "Confirmarea biletelor dumneavoastră a fost trimisă pe fiecare adresă de email"
                ),
              )
            );
          });
        }, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            provider.paymentMethod == PaymentMethod.cash
            ? "Rezervă"
            : "Plătește ${removeDecimalZeroFormat(ticket.price*tripPageProvider.selectedPassengerNumber)}RON",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            children: [
              SizedBox(height: 20,),
              returnTicket != null
              ? Text("Drum plecare", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18),)
              : Container(),

              TripDetails(ticket, tripPageProvider.selectedPassengerNumber, tripPageProvider.passengerData),
              
              SizedBox( height: 20,),
              returnTicket != null
              ? Text("Drum întoarcere", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 18),)
              : Container(),
              returnTicket != null
              ? TripDetails(returnTicket, arrivalTripPageProvider!.selectedPassengerNumber, arrivalTripPageProvider.passengerData)
              : Container(),
              SizedBox(height: 15,),
              Row( /// Row of lines
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(MediaQuery.of(context).size.width ~/ 10, (index) => Text("-", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)))
              ),
              SizedBox(height: 15,),
              returnTicket != null && ticket.roundTripPriceDiscount != 0
              ? Padding( /// Price discount
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Reducere traseu dus-întors", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("-${removeDecimalZeroFormat(ticket.roundTripPriceDiscount)} RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15),)
                  ],
                ),
              )
              : Container(),
              SizedBox(height: 15,),
              Padding( /// Total price
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text(
                      returnTicket != null
                      ? "${removeDecimalZeroFormat(ticket.price*tripPageProvider.selectedPassengerNumber + returnTicket.price*arrivalTripPageProvider!.selectedPassengerNumber - ticket.roundTripPriceDiscount)} RON"
                      : "${removeDecimalZeroFormat(ticket.price*tripPageProvider.selectedPassengerNumber)} RON", 
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Numerar", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18)),
                leading: Radio(
                  value: PaymentMethod.cash,
                  groupValue: provider.paymentMethod,
                  onChanged: provider.updatePaymentMethod,
                ),
              ),
              AbsorbPointer(
                child: Opacity(
                  opacity: 0.4,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Card", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18)),
                    leading: Radio(
                      value: PaymentMethod.card,
                      groupValue: provider.paymentMethod,
                      onChanged: provider.updatePaymentMethod,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100,)
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