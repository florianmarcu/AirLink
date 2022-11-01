
import 'package:flutter/material.dart';
import 'package:transportation_app/screens/authentication/authentication_provider.dart';
import 'package:transportation_app/screens/authentication/components/log_in_form.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthenticationPageProvider>();

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Stack(
        children: [          /// The circle in the upper right corner
          // Positioned(
          //   bottom: -100,
          //   left: -100,
          //   child: Container(
          //     width: 200.0,
          //     height: 200.0,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       shape: BoxShape.circle,
          //     ),
          //   )
          // ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.15, 
              left: MediaQuery.of(context).size.width*0.05,
              right: MediaQuery.of(context).size.width*0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Autentificare", style: Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).primaryColor)),
                SizedBox(height: 20),
                LogInForm(),
                SizedBox(height: 25),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Padding( /// Register button
                //       padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                //       child: Text.rich(TextSpan(
                //         children: [
                //           TextSpan(text: "Nu ai cont?"),
                //           WidgetSpan(child: SizedBox(width: 10)),
                //           WidgetSpan(child: TextButton(
                //             style: Theme.of(context).textButtonTheme.style!.copyWith(
                //               padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                //               backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //               minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                //             ),
                //             child: Text("Înregistrare", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                //               fontSize: 15,
                //               decoration: TextDecoration.underline,
                //               fontWeight: FontWeight.normal,
                //               color: Theme.of(context).colorScheme.secondary
                //             )),
                //             onPressed: () => Navigator.push(context, MaterialPageRoute(
                //               builder: (context) => ChangeNotifierProvider(
                //                 create: (context) => RegisterPageProvider(),
                //                 child: RegisterPage()
                //               )
                //             )),
                //           ),)
                //         ],
                //       ),),
                //     ),
                //     Padding( /// Forgot password button
                //       padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                //       child: Text.rich(TextSpan(
                //         children: [
                //           // TextSpan(text: "Nu ai cont?"),
                //           // WidgetSpan(child: SizedBox(width: 20)),
                //           WidgetSpan(child: TextButton(
                //             style: Theme.of(context).textButtonTheme.style!.copyWith(
                //               padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                //               backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //               minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                //             ),
                //             child: Text("Am uitat parola", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                //               fontSize: 15,
                //               decoration: TextDecoration.underline,
                //               fontWeight: FontWeight.normal,
                //               color: Theme.of(context).colorScheme.secondary
                //             )),
                //             onPressed: () => Navigator.push(context, MaterialPageRoute(
                //               builder: (context) => ChangeNotifierProvider(
                //                 create: (context) => ForgotPasswordPageProvider(),
                //                 child: ForgotPasswordPage()
                //               )
                //             )),
                //           ),)
                //         ],
                //       ),),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20,),
                
                /// Google Sign In Button
                // SizedBox(height: 20,),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: TextButton(
                //     onPressed: () => provider.logIn(context, "google"),
                //     style: Theme.of(context).textButtonTheme.style!.copyWith(
                //       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).highlightColor)
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(localAsset("google"), width: 17,),
                //         SizedBox(width: 20,),
                //         Text("Continuă prin Google", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 14),),
                //       ],
                //     ),
                //   ),
                // ),
                // ///Facebook Sign In Button
                // SizedBox(height: 15,),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: TextButton(
                //     onPressed: () => provider.logIn(context, "facebook"),
                //     style: Theme.of(context).textButtonTheme.style!.copyWith(
                //       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).highlightColor)
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(localAsset("facebook"), width: 17,),
                //         SizedBox(width: 20,),
                //         Text("Continuă prin Facebook", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 14),),
                //       ],
                //     ),
                //   ),
                // ),
                /// Apple Sign In Button - for iOS only
                // SizedBox(height: 10,),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: TextButton(
                //     onPressed: () => {},
                //     style: Theme.of(context).textButtonTheme.style!.copyWith(
                //       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).highlightColor)
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(asset("apple"), width: 17,),
                //         SizedBox(width: 20,),
                //         Text("Continuă prin Apple", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 14),),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          /// The circle in the upper right corner
          Positioned(
            top: -150,
            right: 0,
            child: new Container(
              width: 400.0,
              height: 270.0,
              decoration: new BoxDecoration(
                color:  Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            )
          ),
          /// The circle in the upper right corner
          Positioned(
            top: -200,
            right: -200,
            child: new Container(
              width: 400.0,
              height: 400.0,
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            )
          ),
          provider.isLoading
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
            ), 
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
        ],
      ),
    );
  }
}