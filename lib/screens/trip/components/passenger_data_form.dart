import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/trip/trip_provider.dart';

class PassengerDataForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TripPageProvider>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.arrow_back_ios)
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text("Date pasageri"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        heroTag: "passenger_data",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: () {
          provider.updatePassengerFormFieldComplete(); 
          provider.isPassengerFormFieldComplete 
          ? Navigator.pop(context)
          : {
            ScaffoldMessenger.of(context).clearSnackBars(),
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.fixed,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                content: Text("Trebuie să completați datele pasagerilor"),
              )
            )
          };
        }, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            "Finalizează",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListView.separated( /// List of passengers
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: provider.selectedPassengerNumber,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) => Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container( /// Passenger's index
                        width: 60,
                        decoration: BoxDecoration(
                          //color: Theme.of(context).canvasColor,
                          border: Border.all(),
                          shape: BoxShape.circle
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text("${index+1}", style: Theme.of(context).textTheme.overline,),
                            ),
                            enabled: false
                          ),
                        // onChanged: (email) => provider.setEmail(email),
                        ),
                        // child: Text(
                        //   "${index+1}",
                        //   style: Theme.of(context).textTheme.labelMedium,
                        // ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.03,
                      ),
                      Container( /// Passenger's inputs
                        width: MediaQuery.of(context).size.width*0.7,
                        decoration: BoxDecoration(
                          //color: Theme.of(context).splashColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Column(
                          children: [
                            TextFormField(/// Name input
                              keyboardType: TextInputType.name,
                              initialValue: provider.passengerData[index]['name'] != "" ? provider.passengerData[index]['name'] : null,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                labelText: "Nume",
                                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
                              ),
                              style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
                              onChanged: (name) => provider.updatePassengerName(index, name),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width*0.7,
                              color: Theme.of(context).primaryColor,
                            ),
                            TextFormField(/// Email input
                              keyboardType: TextInputType.emailAddress,
                              initialValue: provider.passengerData[index]['email'] != "" ? provider.passengerData[index]['email'] : null,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                labelText: "Email",
                                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
                              ),
                              style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
                              onChanged: (email) => provider.updatePassengerEmail(index, email),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width*0.7,
                              color: Theme.of(context).primaryColor,
                            ),
                            TextFormField(/// Phone number input
                              key: provider.phoneNumberFormKeys[index],
                              keyboardType: TextInputType.phone,
                              validator: provider.validatePassengerPhoneNumber,
                              initialValue: provider.passengerData[index]['phone_number'] != "" ? provider.passengerData[index]['phone_number'] : null,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),                
                                fillColor: Colors.transparent,
                                labelText: "Telefon",
                                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
                              ),
                              style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
                              onChanged: (phoneNumber) => provider.updatePassengerPhoneNumber(index, phoneNumber),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ChoiceChip(
                                  backgroundColor: Theme.of(context).canvasColor,
                                  selectedColor: Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                                  pressElevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  label: Image.asset(localAsset("backpack"), width: 25,), 
                                  selected: provider.passengerData[index]['luggage']['backpack'],
                                  onSelected: (selected) => provider.updatePassengerLuggage(1, index, selected),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: "Ghiozdan",
                                  child: Image.asset(localAsset("information"), width: 20, color: Theme.of(context).primaryColor,)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ChoiceChip(
                                  backgroundColor: Theme.of(context).canvasColor,
                                  selectedColor: Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                                  pressElevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  label: Image.asset(localAsset("hand"), width: 25,), 
                                  selected: provider.passengerData[index]['luggage']['hand'],
                                  onSelected: (selected) => provider.updatePassengerLuggage(2, index, selected),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: "Bagaj de mână / cabină",
                                  child: Image.asset(localAsset("information"), width: 20, color: Theme.of(context).primaryColor,)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ChoiceChip(
                                  backgroundColor: Theme.of(context).canvasColor,
                                  selectedColor: Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                                  pressElevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  label: Image.asset(localAsset("check-in"), width: 25,), 
                                  selected: provider.passengerData[index]['luggage']['check-in'],
                                  onSelected: (selected) => provider.updatePassengerLuggage(3, index, selected),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: "Bagaj de cală",
                                  child: Image.asset(localAsset("information"), width: 20, color: Theme.of(context).primaryColor,)
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}