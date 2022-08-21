import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';


/// The app's drawer
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var user = context.watch<WrapperHomePageProvider>().currentUser!;
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Drawer(
        child: Column(
          children: [
            user.isAnonymous != true
            ? UserAccountsDrawerHeader(
              accountName: Text(
                user.displayName, 
                style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 25)
              ), 
              accountEmail: Text(user.email != null ? user.email! : ""),
              currentAccountPicture: user.photoURL == null
              ? Icon(Icons.person, size: 40, color: Theme.of(context).highlightColor,)
              : ClipRRect(borderRadius: BorderRadius.circular(30), child: Image.network(user.photoURL!)),
            )
            : Container(height: 200),
            Expanded(
              child: Container(),
            ),
            TextButton(
              child: Text(
                !user.isAnonymous
                ? "Ieși din cont"
                : "Log In"
              ),
              onPressed: () => Authentication.signOut(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.08)
          ],
        ),
      ),
    );
  }
}