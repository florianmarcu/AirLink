import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
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
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            wrapperHomePageProvider.rebuildTicketPageProvider();
            //wrapperHomePageProvider.ticketPageProvider = TicketPageProvider(ticketPageProvider.ticket);
            wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
          provider.makeReservation(ticket, tripPageProvider)
          .then((newTicket){
            wrapperHomePageProvider.pageController.jumpToPage(0);
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
              Padding( /// Departure date
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Data plecării", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("${formatDateToWeekdayAndDate(ticket.departureTime)}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding( /// Departure time
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ora plecării", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("${formatDateToHourAndMinutes(ticket.departureTime)}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding( /// Arrival time
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ora sosirii", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("${formatDateToHourAndMinutes(ticket.arrivalTime)}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding( /// Passenger no
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Număr pasageri", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text.rich(TextSpan( 
                      children: [
                        TextSpan(
                          text:"${tripPageProvider.selectedPassengerNumber}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)
                        ),
                        WidgetSpan(child: SizedBox(width: 10,)),
                        WidgetSpan(
                          child: Icon(Icons.person, size: 17)
                        )
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding( /// Ticket price
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tarif", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    tripPageProvider.selectedPassengerNumber > 1
                    ? Text("${tripPageProvider.selectedPassengerNumber} x ${removeDecimalZeroFormat(ticket.price)} = ${removeDecimalZeroFormat(ticket.price*tripPageProvider.selectedPassengerNumber)} RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                    : Text("${removeDecimalZeroFormat(ticket.price)} RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding( /// Other costs
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Alte costuri", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("0 RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Row( /// Row of lines
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(MediaQuery.of(context).size.width ~/ 10, (index) => Text("-", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)))
              ),
              SizedBox(height: 15,),
              Padding( /// Other costs
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                    Text("${removeDecimalZeroFormat(ticket.price*tripPageProvider.selectedPassengerNumber)} RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15),)
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
              )
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