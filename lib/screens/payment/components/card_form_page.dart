import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:transportation_app/screens/payment/payment_provider.dart';

class CardFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<PaymentPageProvider>();
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
        title: Text("Introdu datele cardului"),
      ),
      body: ListView(
        children: [
          Text("Card form"),
          SizedBox(height: 20,),
          CardFormField(
            enablePostalCode: false,
            // dangerouslyGetFullCardDetails: true,
            // dangerouslyUpdateFullCardDetails: true,
            controller: provider.cardFormEditController,
            style: CardFormStyle(
              cursorColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryColor
            ),
            onCardChanged: provider.updateCardFieldInputDetails,
          ),
          TextButton(
            onPressed: () {
              // provider.cardFormEditController.
              provider.updateCardFieldInputDetails(provider.cardFormEditController.details);
              Navigator.pop(context);
            },
            child: Text("Adaugă"),
          )
        ],
      ),
    );
  }
}