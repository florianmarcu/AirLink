import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/screens/ticket/ticket_provider.dart';

class CupertinoHourPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TicketPageProvider>();
    return Container(
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: provider.selectedDepartureDateAndHour,
              use24hFormat: true,
              mode: CupertinoDatePickerMode.time,
              maximumDate: DateTime.now().toLocal().add(Duration(days: 90)),
              onDateTimeChanged: provider.updateSelectedDepartureDateAndHour,
            ),
          ),
          SizedBox(height: 20,),
          TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
              overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).splashColor.withOpacity(0.3)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Închide", style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).primaryColor
              //color: Color(0xFF393E46)
            ),),
          ),
        ],
      ),
    );
  }
}