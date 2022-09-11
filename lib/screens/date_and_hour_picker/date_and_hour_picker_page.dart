import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/ticket/ticket_provider.dart';

class DateAndHourPickerPage extends StatefulWidget {
  @override
  State<DateAndHourPickerPage> createState() => _DateAndHourPickerPageState();
}

class _DateAndHourPickerPageState extends State<DateAndHourPickerPage> {

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TicketPageProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
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
          child: Text("Data și ora zborului")

        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          !Platform.isIOS
          ? Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).colorScheme.secondary
              )
            ),
            child: CalendarDatePicker(
              initialDate: provider.selectedDepartureDateAndHour, 
              firstDate: DateTime.now().toLocal(), 
              lastDate: DateTime.now().toLocal().add(Duration(days: 90)),
              onDateChanged: provider.updateSelectedDepartureDateAndHour
            ),
          )
          : Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: provider.selectedDepartureDateAndHour,
              maximumDate: DateTime.now().toLocal().add(Duration(days: 90)),
              onDateTimeChanged: provider.updateSelectedDepartureDateAndHour
            ),
          ),
          // Theme(
          //   data: Theme.of(context).copyWith(
          //     canvasColor: Theme.of(context).canvasColor,
          //     colorScheme: Theme.of(context).colorScheme.copyWith(
          //       primary: Theme.of(context).colorScheme.secondary
          //     )
          //   ),
          //   child: showTimePicker(
          //     context: context,
          //     initialTime: TimeOfDay.fromDateTime(provider.selectedDepartureDateAndHour),
              
          //   ),
          // ),
          SizedBox(height: 50),
        ],
      )
    );
  }
}