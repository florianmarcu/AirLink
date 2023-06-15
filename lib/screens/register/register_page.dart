import 'package:flutter/material.dart';
import 'package:transportation_app/screens/register/register_provider.dart';

import 'components/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RegisterPageProvider>();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// The circle in the upper right corner
          Positioned(
            top: -120,
            right: -120,
            child: new Container(
              width: 240.0,
              height: 240.0,
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.2, 
              left: MediaQuery.of(context).size.width*0.05,
              right: MediaQuery.of(context).size.width*0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Înregistrare", style: Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).primaryColor),),
                SizedBox(height: 20),
                RegisterForm(),
                SizedBox(height: 25),
                // Padding(
                //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                //   child: Text.rich(TextSpan(
                //     children: [
                //       TextSpan(text: "Ai deja cont?"),
                //       WidgetSpan(child: SizedBox(width: 20)),
                //       WidgetSpan(child: TextButton(
                //         style: Theme.of(context).textButtonTheme.style!.copyWith(
                //           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                //           backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                //         ),
                //         child: Text("Log in", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                //           fontSize: 15,
                //           decoration: TextDecoration.underline,
                //           fontWeight: FontWeight.normal,
                //           color:  Theme.of(context).colorScheme.secondary
                //         )),
                //         onPressed: (){
                //           Navigator.pop(context);
                //         },
                //       ),)
                //     ],
                //   ),),
                // )
                SizedBox(height: 20)
              ],
            ),
          ),
          /// The circle in the down left corner
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
          /// The circle in the down left corner
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