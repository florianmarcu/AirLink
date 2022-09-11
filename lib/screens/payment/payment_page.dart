import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/payment/payment_provider.dart';
import 'package:transportation_app/screens/ticket/ticket_provider.dart';
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
    var ticketPageProvider = context.watch<TicketPageProvider>();
    var ticket = ticketPageProvider.ticket;
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
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MultiProvider(
          //   providers: [
          //     ChangeNotifierProvider(create: (_) => PaymentPageProvider()),
          //     ChangeNotifierProvider.value(value: wrapperHomePageProvider,)
          //   ],
          //     child: PaymentPage(),
          //   ),
          // ));
          wrapperHomePageProvider.paymentPageProvider = PaymentPageProvider();
          wrapperHomePageProvider.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            provider.paymentMethod == PaymentMethod.cash
            ? "Rezervă"
            : "Plătește ${removeDecimalZeroFormat(ticket.price*ticketPageProvider.selectedPassengerNumber)}RON",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          SizedBox(height: 20,),
          Padding( /// Ticket price
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tarif", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                ticketPageProvider.selectedPassengerNumber > 1
                ? Text("${ticketPageProvider.selectedPassengerNumber} x ${removeDecimalZeroFormat(ticket.price)} = ${removeDecimalZeroFormat(ticket.price*ticketPageProvider.selectedPassengerNumber)} RON")
                : Text("${removeDecimalZeroFormat(ticket.price)} RON")
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
                Text("0 RON")
              ],
            ),
          ),
          SizedBox(height: 15,),
          Row( /// Row of lines
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(MediaQuery.of(context).size.width ~/ 10, (index) => Text("-"))
          ),
          SizedBox(height: 15,),
          Padding( /// Other costs
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                Text("${removeDecimalZeroFormat(ticket.price*ticketPageProvider.selectedPassengerNumber)} RON")
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Card", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18)),
            leading: Radio(
              value: PaymentMethod.card,
              groupValue: provider.paymentMethod,
              onChanged: provider.updatePaymentMethod,
            ),
          )
        ],
      ),
    );
  }
}