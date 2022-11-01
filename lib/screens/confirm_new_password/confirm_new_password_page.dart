import 'package:flutter/material.dart';
import 'package:transportation_app/screens/confirm_new_password/confirm_new_password_provider.dart';

class ConfirmNewPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ConfirmNewPasswordPageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Resetează parola"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.check_circle, color: Colors.green,),),
                  WidgetSpan(child: SizedBox(width: 20)),
                  TextSpan(
                    text: "Un link pentru resetarea parolei a fost trimis pe ",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
                  ),
                  TextSpan(
                    text: "${provider.email}",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17, fontWeight: FontWeight.bold)
                  ),
                  // TextSpan(
                  //   text: ". Dacă nu găsiți emailul, verificați în Spam.",
                  //   style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
                  // ),
                ]
              )
            ),
            SizedBox(height: 20,),
            
          ],
        ),
      ),    
    );
    // return Scaffold(
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   floatingActionButton: FloatingActionButton.extended(
    //     heroTag: "ticket",
    //     elevation: 0,
    //     backgroundColor: Theme.of(context).colorScheme.secondary,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
    //     onPressed: (){
    //       provider.confirmPasswordReset(context);
    //     }, 
    //     label: Container(
    //       alignment: Alignment.center,
    //       width: MediaQuery.of(context).size.width*0.4,
    //       child: Text(
    //         "Continuă",
    //         //"Plătește ${removeDecimalZeroFormat(ticket.price*provider.selectedPassengerNumber)}RON",
    //         style: Theme.of(context).textTheme.headline6,
    //       ),
    //     )
    //   ),
    //   appBar: AppBar(
    //     title: Text("Resetează parola"),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(height: 20),
    //         Text.rich(
    //           TextSpan(
    //             children: [
    //               TextSpan(
    //                 text: "Introduceți codul primit pe ",
    //                 style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
    //               ),
    //               TextSpan(
    //                 text: "${provider.email}",
    //                 style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17, fontWeight: FontWeight.bold)
    //               ),
    //               TextSpan(
    //                 text: ". Dacă nu găsiți emailul, verificați în Spam.",
    //                 style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
    //               ),
    //             ]
    //           )
    //         ),
    //         SizedBox(height: 20,),
    //         /// Email code field
    //         TextFormField(
    //           enabled: true,
    //           keyboardType: TextInputType.text,
    //           initialValue: provider.code,
    //           decoration: InputDecoration(
    //             enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ), 
    //             fillColor: Colors.transparent,
    //             labelText: "Cod",
    //             labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
    //           ),
    //           style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
    //           // onChanged: (email) => provider.updatePassengerEmail(index, email),
    //         ),
    //         SizedBox(height: 20),
    //         Text(
    //           "Introduceți parola nouă",
    //           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
    //         ),
    //         SizedBox(height: 20,),
    //         /// New password field
    //         TextFormField(
    //           enabled: true,
    //           keyboardType: TextInputType.text,
    //           obscureText: true,
    //           initialValue: provider.confirmedPassword,
    //           decoration: InputDecoration(
    //             enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ), 
    //             fillColor: Colors.transparent,
    //             labelText: "Parola nouă",
    //             labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
    //           ),
    //           style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
    //           // onChanged: (email) => provider.updatePassengerEmail(index, email),
    //         ),
    //         SizedBox(height: 20),
    //         Text(
    //           "Confirmați parola nouă",
    //           style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)
    //         ),
    //         SizedBox(height: 20,),
    //         /// Confirmed password field
    //         TextFormField(
    //           enabled: true,
    //           keyboardType: TextInputType.text,
    //           obscureText: true,
    //           initialValue: provider.confirmedPassword,
    //           decoration: InputDecoration(
    //             enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(30),
    //               borderSide: BorderSide(color: Theme.of(context).primaryColor)
    //             ), 
    //             fillColor: Colors.transparent,
    //             labelText: "Confirmă parola nouă",
    //             labelStyle: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor)
    //           ),
    //           style: Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(color: Theme.of(context).primaryColor),
    //           // onChanged: (email) => provider.updatePassengerEmail(index, email),
    //         ),
    //         Expanded(
    //           child: Container(),
    //         ),
    //         provider.isLoading
    //         ? Container(
    //           height: 5,
    //           width: MediaQuery.of(context).size.width,
    //           child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
    //         )
    //         : Container(),
    //       ],
    //     ),
    //   ),
    // );
  }
}