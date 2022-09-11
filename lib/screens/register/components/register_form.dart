import 'package:flutter/material.dart';
import 'package:transportation_app/screens/register/register_provider.dart';

class RegisterForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RegisterPageProvider>();
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Display Name field
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Nume",
            ),
            onChanged: (name) => provider.setName(name),
          ),
          SizedBox(height: 20),
          /// Email field
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
            ),
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
            onChanged: (password) => provider.setPassword(password),
          ),
          SizedBox(height: 30,),
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