import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/models/models.dart';

String formatDateToWeekdayAndDate(DateTime date){
  return "${kWeekdays[DateFormat('EEEE').format(date)]}, ${date.day} ${kMonths[date.month-1]} ${date.year}";
}
String formatDateToWeekdayAndShortDate(DateTime date){
  return "${kWeekdays[DateFormat('EEEE').format(date)]}, ${date.day} ${kMonths[date.month-1].substring(0,3)} ${date.year}";
}
String formatDateToWeekdayDateAndHour(DateTime date){
  return "${kWeekdays[DateFormat('EEEE').format(date)]}, ${date.day} ${kMonths[date.month-1]} ${date.year} \n ${formatDateToHourAndMinutes(date)}";
}
String formatDateToShortDate(DateTime date){
  return "${date.day} ${kMonths[date.month-1].substring(0,3)} ${date.year}";
}

String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

String? formatDateToHourAndMinutes(DateTime? date){
  return date != null
  ? (date.hour > 9 ? date.hour.toString() : "0" + date.hour.toString()) + ":" + (date.minute != 0 ? date.minute.toString() : "00")
  : "";
}

String formatDurationToHoursAndMinutes(Duration duration){
  return duration.inHours.toString() == "0"
  ?  "${duration.inMinutes}m"
  : "${duration.inHours}h ${duration.inMinutes%60}m";
}

String formatPaymentMethod(PaymentMethod paymentMethod){
  switch(paymentMethod){
    case PaymentMethod.card: return "Card";
    default: return "Numerar";
  }
}

formatLuggage(BuildContext context, Map luggage, Color color){
  List<Widget> result = [];
  if(luggage['backpack'])
    result.add(Image.asset(localAsset("backpack"), width: 18, color: color));
  if(luggage['hand'])
    result.add(Image.asset(localAsset("hand"), width: 18, color: color));
  if(luggage['check-in'])
    result.add(Image.asset(localAsset("check-in"), width: 18, color: color));
  return Row(children: result);
}

String formatPassengerDataToLuggage(List passengerData){
  String result = "";
  int backpack = 0;
  int hand = 0;
  int checkIn = 0;
  passengerData.forEach((passenger) {
    backpack += passenger['luggage']['backpack'] ? 1 : 0;
    hand += passenger['luggage']['hand'] ? 1 : 0;
    checkIn += passenger['luggage']['check-in'] ? 1 : 0;
  });

  result += backpack > 0
  ? "${backpack} x Ghiozdan "
  : "";
  result += hand > 0
  ? "${hand} x Bagaj de mână "
  : "";
  result += checkIn > 0
  ? "${backpack} x Bagaj de cală "
  : "";

  return result;
}