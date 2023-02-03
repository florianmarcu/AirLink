import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/date_picker/date_picker_page.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/arrival_date_picker/arrival_date_picker_page.dart';
import 'package:transportation_app/screens/private_trips/private_trips_page.dart';
import 'package:transportation_app/screens/private_trips/private_trips_provider.dart';
import 'package:transportation_app/screens/trips/trips_page.dart';
import 'package:transportation_app/screens/trips/trips_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

import 'components/arrival_cupertino_hour_picker.dart';
import 'components/departure_cupertino_hour_picker.dart';

/// The page from which the user starts the booking process
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<HomePageProvider>();
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: IconButton(
                onPressed: () =>
                    wrapperHomePageProvider.key.currentState!.openDrawer(),
                icon: Icon(
                  Icons.menu,
                  size: 30,
                )
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 20, right: 20, top: 10, bottom: 30),
            children: [
              Container( /// Transport type
                height: 90,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 20),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: TransportationType.values.length,
                  separatorBuilder: (context, index) => SizedBox(width: 15),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => provider.updateTransportationType(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: TransportationType.values[index] == provider.selectedTransportationType ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor
                      ),
                      child: Column(
                        children: [
                          Image.asset(localAsset(TransportationType.values[index].name), color: Theme.of(context).canvasColor, width: 30,),
                          SizedBox(height: 5,),
                          Text(
                            transportationTypeNames[index],
                            style: Theme.of(context).textTheme.overline!.copyWith(
                              color: Theme.of(context).canvasColor
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  /// Querying fields
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  // height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        /// Select departure destination
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("De la",
                              style: Theme.of(context).textTheme.subtitle2),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(30),
                              hint: Text("De la", style: Theme.of(context).textTheme.subtitle1),
                              icon: Icon(Icons.arrow_downward),
                              dropdownColor: Theme.of(context).primaryColor,
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.secondary,
                              isExpanded: true,
                              value: provider.selectedDepartureLocation,
                              items: provider.departureLocations
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged:
                                  provider.updateSelectedDepartureLocation,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Column(
                        /// Select arrival destination
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Până la",
                              style: Theme.of(context).textTheme.subtitle2),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(30),
                                hint: Text("Până la", style: Theme.of(context).textTheme.subtitle1),
                                icon: Icon(Icons.arrow_downward),
                                dropdownColor: Theme.of(context).primaryColor,
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                isExpanded: true,
                                value: provider.selectedArrivalLocation,
                                items: provider.arrivalLocations
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged:
                                    provider.updateSelectedArrivalLocation),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Column(
                        /// Select transportation company
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Companie",
                              style: Theme.of(context).textTheme.subtitle2),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<Company>(
                                borderRadius: BorderRadius.circular(30),
                                // hint: Text(
                                //   "${provider.selectedTransportationCompany}",
                                //   style: Theme.of(context).textTheme.subtitle1,
                                // ),
                                icon: Icon(Icons.arrow_downward),
                                dropdownColor: Theme.of(context).primaryColor,
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                iconDisabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                isExpanded: true,
                                value: provider.selectedTransportationCompany,
                                items: provider.transportationCompanies
                                    .map((e) => DropdownMenuItem<Company>(
                                        value: e, child: Text(e.name)))
                                    .toList(),
                                onChanged: provider
                                    .updateSelectedTransportationCompany),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Column(/// Select date
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Data",
                              style: Theme.of(context).textTheme.subtitle2),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider.value(
                                          value: provider,
                                          child: DatePickerPage(),
                                        ))),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton<DateTime>(
                                borderRadius: BorderRadius.circular(30),
                                hint: Text(
                                  "${formatDateToWeekdayAndDate(provider.selectedDepartureDateAndHour)}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                icon: Icon(Icons.arrow_downward),
                                dropdownColor: Theme.of(context).primaryColor,
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                iconDisabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                isExpanded: true,
                                value: provider.selectedDepartureDateAndHour,
                                items: [],
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                              value: provider,
                                              child: DatePickerPage(),
                                            ))),
                                onChanged: (date) =>
                                    provider.updateSelectedDepartureDate(date!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Visibility(
                        visible: provider.selectedTransportationType == TransportationType.private,
                        child: Column(/// Select hour              
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ora", style: Theme.of(context).textTheme.subtitle2),
                            GestureDetector(
                              onTap: () async{
                                if(!Platform.isIOS){
                                  var time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(provider.selectedDepartureDateAndHour)
                                  );
                                  provider.updateSelectedDepartureHourAndroid(time);
                                }
                                else{
                                  showModalBottomSheet(
                                    context: context, 
                                    builder: (context) => ChangeNotifierProvider.value(
                                      value: provider,
                                      child: DepartureCupertinoHourPickerPage()
                                    )
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton<DateTime>(
                                  borderRadius: BorderRadius.circular(30),
                                  hint: Text(
                                    "${formatDateToHourAndMinutes(provider.selectedDepartureDateAndHour)}",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  icon: Icon(Icons.arrow_downward),
                                  dropdownColor: Theme.of(context).primaryColor,
                                  iconEnabledColor:
                                      Theme.of(context).colorScheme.secondary,
                                  iconDisabledColor:
                                      Theme.of(context).colorScheme.secondary,
                                  isExpanded: true,
                                  value: provider.selectedDepartureDateAndHour,
                                  items: [],
                                  onTap: () async{
                                    if(!Platform.isIOS){
                                      var time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(provider.selectedDepartureDateAndHour)
                                      );
                                      provider.updateSelectedDepartureHourAndroid(time);
                                    }
                                    else{
                                      showModalBottomSheet(
                                        context: context, 
                                        builder: (context) => ChangeNotifierProvider.value(
                                          value: provider,
                                          child: DepartureCupertinoHourPickerPage()
                                        )
                                      );
                                    }
                                  },
                                  onChanged: (date) =>
                                      provider.updateSelectedDepartureDate(date!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              /// Select round-trip
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dus-întors",
                                    style: Theme.of(context).textTheme.subtitle2),
                                Switch.adaptive(
                                  activeColor: Theme.of(context).colorScheme.secondary,
                                  value: provider.roundTrip, 
                                  onChanged: provider.updateRoundTrip
                                ),
                                SizedBox(height: 15),
                              ]
                            ),
                          ],
                        ),
                        Visibility(
                          visible: provider.roundTrip,  
                          child: Column(
                            /// Select date
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text("Data de întoarcere",
                                style: Theme.of(context).textTheme.subtitle2),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider.value(
                                      value: provider,
                                      child: ReturnDatePickerPage(),
                                    )
                                  )
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: DropdownButton<DateTime>(
                                    borderRadius: BorderRadius.circular(30),
                                    hint: Text(
                                      "${formatDateToWeekdayAndDate(provider.selectedArrivalDateAndHour)}",
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    icon: Icon(Icons.arrow_downward),
                                    dropdownColor: Theme.of(context).primaryColor,
                                    iconEnabledColor:
                                        Theme.of(context).colorScheme.secondary,
                                    iconDisabledColor:
                                        Theme.of(context).colorScheme.secondary,
                                    isExpanded: true,
                                    value: provider.selectedArrivalDateAndHour,
                                    items: [],
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider.value(
                                                  value: provider,
                                                  child: ReturnDatePickerPage(),
                                                ))),
                                    onChanged: (date) =>
                                        provider.updateSelectedReturnDate(date!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: provider.roundTrip && (provider.selectedTransportationType == TransportationType.private),  
                          child: Column(
                            /// Select return hour
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text("Ora de întoarcere",
                                style: Theme.of(context).textTheme.subtitle2),
                              GestureDetector(
                                onTap: () async{
                                if(!Platform.isIOS){
                                  var time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(provider.selectedArrivalDateAndHour)
                                  );
                                  provider.updateSelectedArrivalHourAndroid(time);
                                }
                                else{
                                  showModalBottomSheet(
                                    context: context, 
                                    builder: (context) => ChangeNotifierProvider.value(
                                      value: provider,
                                      child: ArrivalCupertinoHourPickerPage()
                                    )
                                  );
                                }
                              },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: DropdownButton<DateTime>(
                                    borderRadius: BorderRadius.circular(30),
                                    hint: Text(
                                      "${formatDateToHourAndMinutes(provider.selectedArrivalDateAndHour)}",
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    icon: Icon(Icons.arrow_downward),
                                    dropdownColor: Theme.of(context).primaryColor,
                                    iconEnabledColor:
                                        Theme.of(context).colorScheme.secondary,
                                    iconDisabledColor:
                                        Theme.of(context).colorScheme.secondary,
                                    isExpanded: true,
                                    value: provider.selectedArrivalDateAndHour,
                                    items: [],
                                    onChanged: (date) =>
                                        provider.updateSelectedReturnDate(date!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 100),
                width: 100,
                child: TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary)
                  ),
                  onPressed: () {
                    provider.selectedTransportationType == TransportationType.private
                    /// Continue with the 'private' transport ticket flow
                    ? Navigator.push(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secAnimation) => MultiProvider( /// Second screen - contains the departures available from the selected data
                        providers: [
                          ChangeNotifierProvider<PrivateTripsPageProvider>(create: (_) => PrivateTripsPageProvider(provider)),
                          ChangeNotifierProvider<HomePageProvider>.value(value: provider),
                          ChangeNotifierProvider<WrapperHomePageProvider>.value(value: wrapperHomePageProvider),
                        ],
                        child: PrivateTripsPage()
                      ),
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (context, animation, secAnimation, child){
                        var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                        return SlideTransition(
                          child: child,
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset(0, 0)
                          ).animate(_animation),
                        );
                      },
                    ))
                    /// Continue with the 'economic' transport ticket flow
                    : Navigator.push(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secAnimation) => MultiProvider( /// Second screen - contains the departures available from the selected data
                        providers: [
                          ChangeNotifierProvider<TripsPageProvider>(create: (_) => TripsPageProvider(provider)),
                          ChangeNotifierProvider<HomePageProvider>.value(value: provider),
                          ChangeNotifierProvider<WrapperHomePageProvider>.value(value: wrapperHomePageProvider),
                        ],
                        child: TripsPage()
                      ),
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (context, animation, secAnimation, child){
                        var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                        return SlideTransition(
                          child: child,
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset(0, 0)
                          ).animate(_animation),
                        );
                      },
                    ));
                    // wrapperHomePageProvider.pageController.nextPage(
                    //     duration: Duration(milliseconds: 300),
                    //     curve: Curves.easeIn);
                  },
                  // onPressed: () => Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => MultiProvider(
                  //     providers: [
                  //       ChangeNotifierProvider(create: (_) => TicketListPageProvider()),
                  //       ChangeNotifierProvider.value(value: provider)
                  //     ],
                  //     child: TicketListPage(),
                  //   )
                  // )),
                  child: Text(
                    "Caută",
                  )
                ),
              ),
            ],
          ),
        ));
  }
}
