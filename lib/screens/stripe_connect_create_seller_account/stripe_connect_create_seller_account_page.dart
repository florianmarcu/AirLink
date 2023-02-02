import 'package:flutter/material.dart';
import 'package:transportation_app/screens/stripe_connect_create_seller_account/stripe_connect_create_seller_account_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StripeConnectCreateSellerAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<StripeConnectCreateSellerAccountPageProvider>();
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async{
              provider.loading();
              var res = await provider.createSellerAccount();
              print(res);
              if(await canLaunchUrlString(res.url))
                await launchUrlString(res.url);
              else print("error");
            },
            child: Text("Creează cont"),
          ),
          // provider.response != null && provider.response.url != null 
          // ? TextButton(
          //   onPressed: () async{
          //     var res = await provider.createSellerAccount();
          //     print(res);
          //   },
          //   child: Text("Finalizează cont"),
          // )
          // : Container()
        ]
      ),),
    );
  }
}