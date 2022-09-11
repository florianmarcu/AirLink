import 'package:intl/intl.dart';
import 'package:transportation_app/config/config.dart';

String formatDateToWeekdayAndDate(DateTime date){
  return "${kWeekdays[DateFormat('EEEE').format(date)]}, ${date.day} ${kMonths[date.month-1]} ${date.year}";
}
String formatDateToWeekdayDateAndHour(DateTime date){
  return "${kWeekdays[DateFormat('EEEE').format(date)]}, ${date.day} ${kMonths[date.month-1]} ${date.year} \n ${formatDateToHourAndMinutes(date)}";
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