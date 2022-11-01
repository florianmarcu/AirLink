import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/home/home_provider.dart';

class ReturnDatePickerPage extends StatefulWidget {
  @override
  State<ReturnDatePickerPage> createState() => _ReturnDatePickerPageState();
}

class _ReturnDatePickerPageState extends State<ReturnDatePickerPage> {

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "date_picker",
        elevation: 0,
        shape: ContinuousRectangleBorder(),
        onPressed: () => Navigator.pop(context), 
        label: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Selectează",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(localAsset("cancel"),),
          ),
        ),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, ),
          child: Text("Data")

        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).colorScheme.secondary
              )
            ),
            child: CalendarDatePicker(
              initialDate: provider.selectedArrivalDate, 
              firstDate: DateTime.now().toLocal(), 
              lastDate: DateTime.now().toLocal().add(Duration(days: 90)),
              onDateChanged: provider.updateSelectedReturnDate
            ),
          )
        ],
      )
    );
  }
}