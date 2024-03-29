import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/screens/contact/contact_page.dart';
import 'package:transportation_app/screens/stripe_connect_create_seller_account/stripe_connect_create_seller_account_page.dart';
import 'package:transportation_app/screens/stripe_connect_create_seller_account/stripe_connect_create_seller_account_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';


/// The app's drawer
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var user = context.watch<WrapperHomePageProvider>().currentUser;
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Drawer(
        child: Column(
          children: [
            /// Drawer header
            Builder(
              builder: (context) {
                return user == null
                ? Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  height: 160,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    Authentication.auth.currentUser!.displayName == null ? "Oaspete" : Authentication.auth.currentUser!.displayName!, 
                    style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 25, color: Theme.of(context).canvasColor)
                  ),
                )
                : UserAccountsDrawerHeader(
                  accountName: Text(
                    Authentication.auth.currentUser!.displayName == null ? "Oaspete" : Authentication.auth.currentUser!.displayName!, 
                    style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 25, color: Theme.of(context).canvasColor)
                  ), 
                  accountEmail: Text(user.email != null ? user.email! : "", style: Theme.of(context).textTheme.caption),
                  currentAccountPicture: user.photoURL == null
                  ? Icon(Icons.person, size: 40, color: Theme.of(context).highlightColor,)
                  : ClipOval(child: Image.network(user.photoURL!,  width: 30, height: 30, fit: BoxFit.cover), ),
                );
              }
            ),
            /// Contact
            MaterialButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                value: wrapperHomePageProvider,
                child: ContactPage()))
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(Icons.mail),
                    SizedBox(width: 30),
                    Text("Contact", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16
                      // fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ),
            ),
            wrapperHomePageProvider.currentUser!= null && wrapperHomePageProvider.currentUser!.isAdmin == true
            ? TextButton(
              child: Text(
                "Adaugă seller"
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                create: (_) => StripeConnectCreateSellerAccountPageProvider(),
                child: StripeConnectCreateSellerAccountPage()
                ))),
            )
            : Container(),
            Expanded(
              child: Container(),
            ),
            TextButton(
              child: Text(
                user != null && !user.isAnonymous
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