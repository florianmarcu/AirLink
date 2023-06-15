import 'package:flutter/material.dart';

const kMonths = ["Ianuarie", "Februarie",  "Martie",  "Aprilie", "Mai", "Iunie", "Iulie", "August", "Septembrie", "Octombrie", "Noiembrie", "Decembrie"];
const kWeekdays ={"Monday" : "Luni", "Tuesday" : "Marți","Wednesday" : "Miercuri","Thursday" : "Joi","Friday" : "Vineri","Saturday" : "Sâmbătă", "Sunday" : "Duminică"};
const kGoogleMapsApiKey = "AIzaSyAnNnsSwvvVRSH87QzjaxFfy9Ig0n1jZl4";
const kAirlineCompanies = [
  "Aer Arann",
  "Aer Lingus",
  "Aeroflot Russian Airlines",
  "Aeroflot",
  "Aerolineas Argentinas",
  "Aeromexico",
  "Aerosvit Airlines",
  "Afriqiyah Airways",
  "Aigle Azur",
  "Air Algerie",
  "Air Alps",
  "Air Armenia",
  "Air Atlanta Icelandic",
  "Air Austral",
  "Air Cairo",
  "Air Canada",
  "Air China",
  "Air Comet",
  "Air Dolomiti",
  "Air Europa",
  "Air Finland",
  "Air France",
  "Air Greenland",
  "Air India",
  "Air Italy",
  "Air Madagascar",
  "Air Malta",
  "Air Mauritius",
  "Air Mediterranee",
  "Air Memphis",
  "Air Moldov",
  "Air New Zealand",
  "Air Nostrum",
  "Air One",
  "Air Senegal International",
  "Air Seychelles",
  "Air Slovakia",
  "Air Transat",
  "AirVallee",
  "airBaltic",
  "airberlin",
  "Airlinair",
  "Albanian Airlines",
  "Alidaunia",
  "Alitalia",
  "Alitalia Express",
  "AMC Airlines",
  "American Airlines",
  "ANA – All Nippon Airways",
  "Arkefly",
  "Arkia",
  "Armavia",
  "Astraeus",
  "Atlantic Airways (Faroe Islands)",
  "Atlas Blue",
  "Atlasjet Airlines",
  "Aurela",
  "Aurigny Air Services",
  "Austrian",
  "Avianca",
  "AVIES Air Company",
  "Azerbaijan Airlines",
  "B H Air",
  "Baltic Airline",
  "Baboo",
  "Belair Airlines",
  "Belavia",
  "Biman Bangladesh Airlines",
  "Binter Canarias",
  "Blue 1",
  "Blue Air",
  "Blue Line",
  "Blue Panorama Airlines",
  "Blue Wing Airlines",
  "bmi",
  "bmibaby",
  "British Airways",
  "Brussels Airlines",
  "Bulgaria Air",
  "Bulgarian Air Charter",
  "Carpatair",
  "Cathay Pacific",
  "CCM Airlines",
  "Central Connect Airlines",
  "China Airlines",
  "Cimber Air",
  "Cirrus Airlines",
  "City Airline",
  "Clickair",
  "Compagnie Aérienne du Mali",
  "Condor Flugdienst",
  "Continental Airlines",
  "Corsairfly",
  "Croatia Airlines",
  "CSA Czech Airlines",
  "Cubana",
  "Cyprus Airways",
  "Danu Oro Transportas",
  "Darwin Airline",
  "DAT- Danish Air Transport",
  "DeltaAirlines",
  "Dniproavia",
  "Donbassaero",
  "Dubrovnik Airline",
  "Eastern Airways",
  "EasyJet",
  "EasyJet Switzerland",
  "Edelweiss Air",
  "Egyptair",
  "El Al",
  "Emirates Airline",
  "Eritrean Airlines",
  "Estonian Air",
  "Ethiopian Airlines",
  "Etihad Airways",
  "Euroair",
  "Eurocypria Airlines",
  "Eurofly",
  "Europe Airpost",
  "European Aircharter",
  "Eurowings",
  "EVA Air",
  "Finnair",
  "FinnComm Airlines",
  "First Choice Airways",
  "Flightline",
  "Flybe",
  "flyglobespan",
  "flyLAL",
  "Freebird Airlines",
  "GB Airways",
  "Georgian Airways",
  "Germanwings",
  "Gir Jet",
  "Golden Air",
  "Gulf Air",
  "Hahn Air",
  "Hamburg International",
  "Hello",
  "Helvetic Airways",
  "Hemus Air",
  "Hex Air",
  "Hola Airlines",
  "IBA International Business Air",
  "Iberia",
  "Iberworld",
  "Icelandair",
  "InterSky",
  "Interstate Airlines",
  "Great Lakes Airlines",
  "Gulfstream International Airlines",
  "Hainan Airlines",
  "Hawaiian Airlines",
  "Hebridean Air Services",
  "Hellenic Imperial Airways",
  "Himalayan Airlines",
  "Hong Kong Airlines",
  "HOP!",
  "Iberia Express",
  "Iceland Express",
  "IndiGo Airlines",
  "Indonesia AirAsia",
  "Interjet",
  "Iraqi Airways",
  "Island Air",
  "Israir Airlines",
  "Jazeera Airways",
  "Jet Airways (India)",
  "JetBlue Airways",
  "Jetstar Airways",
  "Jetstar Asia Airways",
  "Jetstar Pacific Airlines",
  "Juneyao Airlines",
  "Kenya Airways",
  "Kingfisher Airlines",
  "Kish Air",
  "KLM Asia",
  "Korean Air Lines",
  "Kunming Airlines",
  "LAM Mozambique Airlines",
  "Lao Airlines",
  "LATAM Airlines",
  "LATAM Argentina",
  "LATAM Brasil",
  "LATAM Chile",
  "LATAM Colombia",
  "LATAM Ecuador",
  "LATAM Paraguay",
  "LATAM Peru",
  "Liat",
  "Lion Air",
  "LIAT",
  "LOT Polish Airlines",
  "Lucky Air",
  "Lufthansa Cargo",
  "Lufthansa CityLine",
  "Luxair",
  "MacAir Airlines",
  "Mahalo Air",
  "Malaysia Airlines",
  "Maldivian",
  "Mandarin Airlines",
  "Manx2",
  "Maya Island Air",
  "Merpati Nusantara Airlines",
  "MIAT Mongolian Airlines",
  "Mokulele Airlines",
  "Monarch Airlines",
  "Montenegro Airlines",
  "Myanmar Airways International",
  "NAC- North Atlantic Air",
  "National Airlines",
  "Nauru Airlines",
  "Neos",
  "Nesma Airlines",
  "NextJet",
  "Niki",
  "Nok Air",
  "Norwegian Air Argentina",
  "Norwegian Air International",
  "Norwegian Air Shuttle",
  "Norwegian Long Haul",
  "Novoair",
  "Olympic Air",
  "Oman Air",
  "OneJet",
  "Onur Air",
  "Orange Air",
  "Orenair",
  "Orient Thai Airlines",
  "Overland Airways",
  "Pakistan International Airlines",
  "Panair do Brasil",
  "Pantanal Linhas Aéreas",
  "Papillon Airways",
  "Passaredo Transportes Aéreos",
  "Peach",
  "Pegasus Airlines",
  "Pelican Air",
  "Pem Air",
  "PenAir",
  "Peruvian Airlines",
  "Philippine Airlines",
  "Polar Air Cargo",
  "Porter Airlines",
  "Precision Air",
  "Proflight Zambia",
  "QantasLink",
  "QantasLink",
  "Qeshm Air",
  "Ravn Alaska",
  "Red Wings Airlines",
  "Regional Express Airlines",
  "Rex Regional Express",
  "Rossiya Airlines",
  "Royal Air Force",
  "Royal Air Force of Oman",
  "Royal Air Maroc Express",
  "Royal Brunei Airlines",
  "Royal Jordanian",
  "RusLine",
  "RwandAir",
  "Safi Airways",
  "Santa Barbara Airlines",
  "SAS Scandinavian Airlines",
  "SATA Air Açores",
  "SATA Azores Airlines",
  "Saudia",
  "Scoot",
  "Seaborne Airlines",
  "Shandong Airlines",
  "Shanghai Airlines",
  "Shenzhen Airlines",
  "Sichuan Airlines",
  "SilkAir",
  "Singapore Airlines Cargo",
  "Sky Airline",
  "Sky Express",
  "Sky Regional Airlines",
  "SkyBahamas Airlines",
  "SkyWest Airlines",
  "Somon Air",
  "Southwest Airlines",
  "SpiceJet",
  "Spirit Airlines",
  "SriLankan Airlines",
  "Star Peru",
  "Sudan Airways",
  "Sun Air Express",
  "Sun Country Airlines",
  "Sundair",
  "Sunrise Airways",
  "Surinam Airways",
  "Swift Air",
  "SWISS",
  "Swiss International Air Lines",
  "TAAG",
  "Syrianair",
  "TACV Cabo Verde Airlines",
  "TAM Linhas Aereas",
  "TAP Portugal",
  "TAROM",
  "Tatarstan Air",
  "Thai Airways International",
  "Thomas Cook Airlines",
  "Thomas Cook Airlines Belgium",
  "Thomas Cook Airlines Scandinavia",
  "Thomson Airways",
  "Titan Airways",
  "TNT Airways",
  "Transaero",
  "Transavia Airlines",
  "Transavia France",
  "Travel Service Airlines",
  "Travel Service Hungary",
  "TUIFly",
  "TUIFly Nordic AB",
  "Tunisair",
  "Turkish Airlines (THY)",
  "Turkmenistan Airlines",
  "Twin Jet",
  "Ukraine International Airlines",
  "UM Air",
  "United Airlines",
  "Ural Airlines",
  "US Airways",
  "UTAir",
  "Uzbekistan Airways",
  "VARIG  VRG Linhas Aereas",
  "Varig Log",
  "VIA  Air VIA",
  "Viking Airlines",
  "VIM Airlines",
  "VLM Airlines",
  "Virgin Atlantic Airlines",
  "Volare S.p.A.",
  "Vueling Airlines",
  "Welcome Air",
  "Wideroe",
  "Wind Jet",
  "Wizz Air",
  "World Airways",
  "XL Airways France",
  "XL Airways Germany",
  "Yemenia"
];
const Map<String, List<String>> kFilters = {
  "sorts":[
    "distance"
  ]
};

class WeirdTopBorder extends ShapeBorder {
  final double radius;
  final double pathWidth;

  WeirdTopBorder({required this.radius, this.pathWidth = 1});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect, textDirection: textDirection!), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _createPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => WeirdTopBorder(radius: radius);

  Path _createPath(Rect rect) {
    final innerRadius = radius + pathWidth;
    final innerRect = Rect.fromLTRB(rect.left + pathWidth, rect.top + pathWidth, rect.right - pathWidth, rect.bottom - pathWidth);

    final outer = Path.combine(PathOperation.difference, Path()..addRect(rect), _createBevels(rect, radius));
    final inner = Path.combine(PathOperation.difference, Path()..addRect(innerRect), _createBevels(rect, innerRadius));
    return Path.combine(PathOperation.difference, outer, inner);
  }

  Path _createBevels(Rect rect, double radius) {
    return Path()
      ..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top), radius: radius));
      //..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top + rect.height), radius: radius))
      //..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top + rect.height), radius: radius));
  }
}

class WeirdBottomBorder extends ShapeBorder {
  final double radius;
  final double pathWidth;

  WeirdBottomBorder({required this.radius, this.pathWidth = 1});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect, textDirection: textDirection!), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _createPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => WeirdBottomBorder(radius: radius);

  Path _createPath(Rect rect) {
    final innerRadius = radius + pathWidth;
    final innerRect = Rect.fromLTRB(rect.left + pathWidth, rect.top + pathWidth, rect.right - pathWidth, rect.bottom - pathWidth);

    final outer = Path.combine(PathOperation.difference, Path()..addRect(rect), _createBevels(rect, radius));
    final inner = Path.combine(PathOperation.difference, Path()..addRect(innerRect), _createBevels(rect, innerRadius));
    return Path.combine(PathOperation.difference, outer, inner);
  }

  Path _createBevels(Rect rect, double radius) {
    return Path()
      //..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top), radius: radius))
      //..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top + rect.height), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top + rect.height), radius: radius));
  }
}

var emailTemplate;