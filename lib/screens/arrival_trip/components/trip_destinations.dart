import 'package:flutter/material.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';

class TripDestinationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TripPageProvider>();
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
        title: Column(
          children: [
            Text(
              "Destinații intermediare"
            ),
            Text(
              "(ordine alfabetică)", style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: provider.ticket.destinations.length,
        separatorBuilder: (context, index) => SizedBox(height: 20),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(10),
          child: Text("${provider.ticket.destinations[index]}"),
        ),
      )
    );
  }
}