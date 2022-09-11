import 'package:flutter/material.dart';

class PaymentPageProvider with ChangeNotifier{
  PaymentMethod paymentMethod = PaymentMethod.cash;

  void updatePaymentMethod(PaymentMethod? paymentMethod){
    this.paymentMethod = paymentMethod!;

    notifyListeners();
  }

}

enum PaymentMethod{
  cash,
  card
}