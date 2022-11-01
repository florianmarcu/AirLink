import 'package:flutter/material.dart';
import 'package:transportation_app/screens/authentication/authentication_provider.dart';
import 'package:transportation_app/screens/forgot_password/forgot_password_page.dart';
import 'package:transportation_app/screens/forgot_password/forgot_password_provider.dart';
import 'package:transportation_app/screens/register/register_page.dart';
import 'package:transportation_app/screens/register/register_provider.dart';

class LogInForm extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthenticationPageProvider>();
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Email field
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
            onChanged: (email) => provider.setEmail(email),
          ),
          const SizedBox(height: 20),
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
            onChanged: (password) => provider.setPassword(password),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding( /// Register button
                  padding: EdgeInsets.only(
                    // left: 10,
                    // right: 10
                  ),
                  child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: "Nu ai cont?"),
                      WidgetSpan(child: SizedBox(width: 10)),
                      WidgetSpan(child: TextButton(
                        style: Theme.of(context).textButtonTheme.style!.copyWith(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                        ),
                        child: Text("Înregistrare", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.secondary
                        )),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => RegisterPageProvider(),
                            child: RegisterPage()
                          )
                        )),
                      ),)
                    ],
                  ),),
                ),
                Padding( /// Forgot password button
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                  child: Text.rich(TextSpan(
                    children: [
                      // TextSpan(text: "Nu ai cont?"),
                      // WidgetSpan(child: SizedBox(width: 20)),
                      WidgetSpan(child: TextButton(
                        style: Theme.of(context).textButtonTheme.style!.copyWith(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all<Size>(Size.zero)
                        ),
                        child: Text("Am uitat parola", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.secondary
                        )),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ForgotPasswordPageProvider(),
                            child: ForgotPasswordPage()
                          )
                        )),
                      ),)
                    ],
                  ),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => provider.logIn(context, "email_and_password"),
                child: Text("Log in"),
                style: Theme.of(context).textButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary)
                ),
              ),
              TextButton(
                onPressed: () => provider.logIn(context, "anonimously"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Sari peste"),
                    SizedBox(width: 20,),
                    Icon(Icons.arrow_forward_ios, size: 15)
                  ],
                ),
                style: Theme.of(context).textButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary)
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}