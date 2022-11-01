import 'package:flutter/cupertino.dart';
export 'package:provider/provider.dart';

class OnboardingPageProvider with ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;

  void updateSelectedPageIndex(int index){
    pageIndex = index;

    notifyListeners();
  }

  var pages = [
    {
      "image": "transport-to-airport",
      "title": "Bun venit",
      "content": "Găsește transportul cel mai ieftin și rapid către aeroport."
    },
    {
      "image": "browse-options",
      "title": "Alege traseul perfect",
      "content": "Introdu ziua, plecarea și destinația transportului tău și alege ora potrivită din traseele disponibile."
    },
    {
      "image": "fill-data",
      "title": "Introdu datele tale",
      "content": "Completează numele, adresa de email, numărul de bagaje și alte date ale zborului."
    },
    {
      "image": "order-confirmed",
      "title": "Bilet confirmat!",
      "content": "Gata, ai primit biletul pe adresa de email, și ai transportul către aeroport asigurat.",
    }
  ];
}
