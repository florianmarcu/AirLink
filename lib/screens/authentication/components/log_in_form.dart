import 'package:flutter/material.dart';
import 'package:transportation_app/screens/authentication/authentication_provider.dart';

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