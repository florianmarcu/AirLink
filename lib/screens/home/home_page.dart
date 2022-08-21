import 'package:flutter/material.dart';
import 'package:transportation_app/screens/home/home_provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20, right: 20, top: MediaQuery.of(context).padding.top),
        children: [
          Container( /// Departure and Arrival selection
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).colorScheme.tertiary
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "De la",
                        style: Theme.of(context).textTheme.subtitle2
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(30),
                          hint: Text(
                            "De la",
                            style: Theme.of(context).textTheme.subtitle1
                          ),
                          icon: Icon(Icons.arrow_downward),
                          iconEnabledColor: Theme.of(context).colorScheme.secondary,
                          isExpanded: true,
                          value: provider.selectedDepartureLocation,
                          items: provider.departureLocations.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e)
                          )).toList(),
                          onChanged: provider.updateSelectedDepartureIndex,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pana la",
                        style: Theme.of(context).textTheme.subtitle2
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(30),
                          hint: Text("Pana la"),
                          icon: Icon(Icons.arrow_downward),
                          iconEnabledColor: Theme.of(context).colorScheme.secondary,
                          isExpanded: true,
                          value: provider.selectedArrivalLocation,
                          items: provider.arrivalLocations.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e)
                          )).toList(),
                          onChanged: provider.updateSelectedArrivalIndex
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
          SizedBox(
            height: 20
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Row(
              children: [
                DatePickerDialog(
                  initialDate: DateTime.now().toLocal(), 
                  firstDate: DateTime.now().toLocal(), 
                  lastDate: DateTime.now().toLocal().add(Duration(days: 90))
                )
              ],
            )
          )
        ],
      )
    );
  }
}