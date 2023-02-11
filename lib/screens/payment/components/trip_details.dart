import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_provider.dart';

class TripDetails extends StatelessWidget {
  final Ticket ticket;
  final int passengersNo;
  final List passengerData;
  final bool? childSeat;
  final double childSeatPrice;
  final TransportationType transportationType;
  
  TripDetails(this.ticket, this.passengersNo, this.passengerData, this.transportationType, this.childSeat, this.childSeatPrice);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
                      text:"${passengersNo}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)
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
          Padding( /// Luggages
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bagaje", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: passengerData.map(
                      (passenger) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            formatLuggage(context, passenger['luggage'], Theme.of(context).primaryColor),
                            SizedBox(width: 10,),
                            Container(
                              width: 30,
                              child: Stack(
                                children: [
                                  Icon(Icons.person, size: 20,color: Theme.of(context).primaryColor),
                                  Positioned(
                                    top: 0 ,
                                    right: 0,
                                    child: Text("${passengerData.indexOf(passenger)+1}", style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor))
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ).toList(),
                  ),
              ],
            ),
          ),
          
          Column(children: [
            SizedBox(height: 20,),
            Padding( /// Child seat
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Scaun copil", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                  Text.rich(TextSpan( 
                    children: [
                      TextSpan(
                        text: childSeat == true ? "Da (${ticket.childSeatPrice} RON)" : "Nu", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)
                      ),
                    ],
                  )),
                ],
              ),
            ),

          ],),
          SizedBox(height: 20,),
          Padding( /// Ticket price
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15)),
                passengersNo > 1 && transportationType != TransportationType.private
                ? Text("${passengersNo} x ${removeDecimalZeroFormat(ticket.price)} = ${removeDecimalZeroFormat(ticket.price*passengersNo)} RON", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15))
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
      ],
    );
  }
}