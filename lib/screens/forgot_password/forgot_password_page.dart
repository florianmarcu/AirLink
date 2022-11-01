import 'package:flutter/material.dart';
import 'package:transportation_app/screens/forgot_password/forgot_password_provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ForgotPasswordPageProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "ticket",
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
        onPressed: (){
          provider.sendPasswordResetEmail(context);
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => ChangeNotifierProvider(
          //     create: (context) => ForgotPasswordPageProvider(),
          //     child: ForgotPasswordPage()
          //   )
          // ));
        }, 
        label: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(
            "Continuă",
            //"Plătește ${removeDecimalZeroFormat(ticket.price*provider.selectedPassengerNumber)}RON",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ),
      appBar: AppBar(
        title: Text("Resetează parola"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Introduceți adresa de email",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
            ),
            SizedBox(height: 20,),
            /// Email field
            TextFormField(
              enabled: true,
              keyboardType: TextInputType.emailAddress,
              initialValue: provider.email,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ), 
                fillColor: Colors.transparent,
                labelText: "Email",
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
              ),
              style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
              onChanged: (email) => provider.setEmail(email),
            ),
            Expanded(
              child: Container(),
            ),
            provider.isLoading
            ? Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
            )
            : Container(),
          ],
        ),
      ),
    );
  }
}