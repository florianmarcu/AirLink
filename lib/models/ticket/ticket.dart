class Ticket{
  String id;
  String departureLocationId;
  String departureLocationName;
  String arrivalLocationId;
  String arrivalLocationName;  
  DateTime departureTime;
  DateTime arrivalTime;
  String companyId;
  String companyName;
  double price;

  Ticket({
    required this.id,
    required this.departureLocationId,
    required this.departureLocationName,
    required this.arrivalLocationId,
    required this.arrivalLocationName,
    required this.departureTime,
    required this.arrivalTime,
    required this.companyId,
    required this.companyName,
    required this.price
  });

}