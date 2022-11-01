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