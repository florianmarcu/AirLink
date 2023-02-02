import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
export 'package:provider/provider.dart';


class StripeConnectCreateSellerAccountPageProvider with ChangeNotifier{
  var createAccountUrl = "https://us-central1-airlink-63554.cloudfunctions.net/StripeConnectCreateAccount";
  var headers = {"Content-Type": "application/json"};
  var response;
  bool isLoading = false;

  Future<CreateAccountResponse> createSellerAccount() async {
    var url = Uri.parse(createAccountUrl);
    var response = await http.get(url, headers: headers);
    Map<String, dynamic> body = jsonDecode(response.body);
    this.response =  CreateAccountResponse(body['url'], true);
    notifyListeners();
    return this.response;
  }
  
  loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}

class CreateAccountResponse {
  late String url;
  late bool success;

  CreateAccountResponse(String url, bool success) {
    this.url = url;
    this.success = success;
  }
}