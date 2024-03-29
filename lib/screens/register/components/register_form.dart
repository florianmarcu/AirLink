import 'package:flutter/material.dart';
import 'package:transportation_app/screens/register/register_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RegisterPageProvider>();
    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Display Name field
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Nume",
            ),
            validator: provider.validateName,
            onChanged: (name) => provider.setName(name),
          ),
          SizedBox(height: 20),
          /// Email field
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
            ),
            validator: provider.validateEmail,
            onChanged: (email) => provider.setEmail(email),
          ),
          SizedBox(height: 20),
          /// Password field
          TextFormField(
            obscureText: !provider.passwordVisible,
            decoration: InputDecoration(
              labelText: "Parolă", 
              suffixIcon: IconButton(
                highlightColor: Colors.grey[200],
                splashColor: Colors.grey[400],
                icon: Icon(Icons.visibility, color: Theme.of(context).highlightColor,), 
                onPressed: () => provider.setPasswordVisibility(), 
                padding: EdgeInsets.zero, 
              ),
            ),
            validator: provider.validatePassword,
            onChanged: (password) => provider.setPassword(password),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
            child: Text.rich(TextSpan(
              children: [
                TextSpan(text: "Ai deja cont?"),
                WidgetSpan(child: SizedBox(width: 20)),
                WidgetSpan(child: TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                  ),
                  child: Text("Log in", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal,
                    color:  Theme.of(context).colorScheme.secondary
                  )),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),)
              ],
            ),),
          ),
          SizedBox(height: 30,),
          ///Privacy policy
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Am citit și accept ", style: Theme.of(context).textTheme.bodyText2
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                        onTap: () async{
                          if(await canLaunchUrlString("https://firebasestorage.googleapis.com/v0/b/airlink-63554.appspot.com/o/documents%2FAirlink%20-%20Politica.pdf?alt=media&token=4aa51df1-2c5f-40ff-9900-5859a05dfad6")){
                            launchUrlString("https://firebasestorage.googleapis.com/v0/b/airlink-63554.appspot.com/o/documents%2FAirlink%20-%20Politica.pdf?alt=media&token=4aa51df1-2c5f-40ff-9900-5859a05dfad6");
                          }
                        },
                          child: Text("politica de confidențialitate", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary)),
                        )
                      ),
                      TextSpan(
                        text: "."
                      ),
                    ]
                  ),
                ),
                Checkbox(
                  fillColor: MaterialStateProperty.all<Color>(Colors.green),
                  side: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1),
                  value: provider.isPrivacyPolicyAgreed, 
                  onChanged: provider.updateIsPrivacyPolicyAgreed
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Am citit și accept ", style: Theme.of(context).textTheme.bodyText2
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () async{
                        if(await canLaunchUrlString("https://firebasestorage.googleapis.com/v0/b/airlink-63554.appspot.com/o/documents%2FAirLink%20-%20T%26C.pdf?alt=media&token=9c4652f9-4218-449f-9163-fa7001c4efa3")){
                          launchUrlString("https://firebasestorage.googleapis.com/v0/b/airlink-63554.appspot.com/o/documents%2FAirLink%20-%20T%26C.pdf?alt=media&token=9c4652f9-4218-449f-9163-fa7001c4efa3");
                        }
                      },
                      child: Text("termenii și condițiile", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary)),
                    )
                  ),
                  TextSpan(
                    text: ".", style: Theme.of(context).textTheme.bodyText2
                  ),
                ])),
                Checkbox(
                  fillColor: MaterialStateProperty.all<Color>(Colors.green),
                  side: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1),
                  value: provider.isTermsAndConditionsAgreed, 
                  onChanged: provider.updateIsTermsAndConditionsAgreed
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary)              
            ),
            onPressed: () => provider.register(context),
            child: Text("Înregistrare"),
          )
        ],
      )
    );
  }
}