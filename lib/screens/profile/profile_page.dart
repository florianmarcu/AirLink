import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
                onPressed: () =>
                    wrapperHomePageProvider.key.currentState!.openDrawer(),
                icon: Icon(
                  Icons.menu,
                  size: 30,
                )),
          )
        ],
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                wrapperHomePageProvider
                    .screenLabels[wrapperHomePageProvider.selectedScreenIndex]
                    .label!,
              )),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Text.rich(TextSpan(children: [
              WidgetSpan(child: Icon(Icons.person, size: 23)),
              WidgetSpan(
                  child: SizedBox(
                width: 20,
              )),
              TextSpan(
                  text: "Date personale",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Theme.of(context).primaryColor))
            ])),
          ),

          /// Email address
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("Adresă de email",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("${Authentication.auth.currentUser!.email}",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 18)),
          ),

          /// Name
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("Nume",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("${Authentication.auth.currentUser!.displayName}",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 18)),
          ),

          /// Phone number
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("Număr de telefon",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
                Authentication.auth.currentUser!.phoneNumber != null &&
                        Authentication.auth.currentUser!.phoneNumber != ""
                    ? "${Authentication.auth.currentUser!.phoneNumber}"
                    : "Nu este setat",
                style: Authentication.auth.currentUser!.phoneNumber != null &&
                        Authentication.auth.currentUser!.phoneNumber != ""
                    ? Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 18)
                    : Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.6))),
          ),

          /// Payment method
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Text.rich(TextSpan(children: [
              WidgetSpan(child: Image.asset(localAsset("card"), width: 23)),
              WidgetSpan(
                  child: SizedBox(
                width: 20,
              )),
              TextSpan(
                  text: "Metodă de plată",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Theme.of(context).primaryColor))
            ])),
          ),
          SizedBox(height: 20),

          /// Payment Method
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
                Authentication.auth.currentUser!.phoneNumber != null &&
                        Authentication.auth.currentUser!.phoneNumber != ""
                    ? "${Authentication.auth.currentUser!.phoneNumber}"
                    : "Nu este setat",
                style: Authentication.auth.currentUser!.phoneNumber != null &&
                        Authentication.auth.currentUser!.phoneNumber != ""
                    ? Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 18)
                    : Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.6))),
          ),
        ],
      ),
    );
  }
}
