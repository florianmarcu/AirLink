import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transportation_app/config/config.dart';
import 'package:transportation_app/screens/profile/profile_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<ProfilePageProvider>();
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton.extended(
      //   heroTag: "ticket",
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
      //   onPressed: (){

      //   },
      //   label: Container(
      //     alignment: Alignment.center,
      //     width: MediaQuery.of(context).size.width*0.4,
      //     child: Text(
      //       "Salvează modificările",
      //       //"Plătește ${removeDecimalZeroFormat(ticket.price*provider.selectedPassengerNumber)}RON",
      //       style: Theme.of(context).textTheme.headline6,
      //     ),
      //   )
      // ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async{
                  await provider.updateProfileImage();
                },
                child: Center(
                  child: ClipOval(
                    child: Authentication.auth.currentUser!.photoURL != null
                    ? Image.network(
                      Authentication.auth.currentUser!.photoURL!, 
                      width: 100, 
                      height: 100, 
                      fit: BoxFit.cover
                    )
                    : Icon(Icons.person, size: 20), 
                  ),
                ),
              ),
              SizedBox(height: 30,),
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
              SizedBox(height: 100),
              GestureDetector(
                onTap: () async{
                  await showFirstAccountDeletionDialog(context, provider);
                },
                child: Center(
                  child: Text("Șterge contul", style: Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: TextDecoration.underline),),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

showFirstAccountDeletionDialog(BuildContext context, ProfilePageProvider provider) => showCupertinoDialog(
  context: context, 
  barrierDismissible: true,
  builder: (context){
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 180,
        // width: 220,
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Urmează să ștergi contul. Toate datele asociate contului tău vor fi șterse",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                    side: MaterialStatePropertyAll(BorderSide(width: 1, color: Theme.of(context).primaryColor)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), )),
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).highlightColor)),
                  onPressed: (){
                    Navigator.pop(context);
                    showSecondAccountDeletionDialog(context ,provider);
                  },
                  child: Text(
                    "Continuă",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(width: 30,),
                TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor)),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Renunță"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
);

showSecondAccountDeletionDialog(BuildContext context, ProfilePageProvider provider) => showCupertinoDialog(
  context: context, 
  barrierDismissible: true,
  builder: (context){
    return Dialog(
      child: Container(
        height: 180,
        // width: 200,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Ești sigur? Ștergerea este ireversibilă!",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                    side: MaterialStatePropertyAll(BorderSide(width: 1, color: Theme.of(context).primaryColor)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), )),
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).highlightColor)),
                  onPressed: () async{
                    Navigator.pop(context);
                    await showThirdAccountDeletionDialog(context, provider);
                  },
                  child: Text(
                    "Șterge",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(width: 30,),
                TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor)),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Renunță"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
);

showThirdAccountDeletionDialog(BuildContext context, ProfilePageProvider provider) => showCupertinoDialog(
  context: context, 
  barrierDismissible: true,
  builder: (context){
    return Dialog(
      child: Container(
        height: 300,
        width: 200,
        padding: EdgeInsets.all(10),
        child: Form(
          key: provider.formKey,
          child: Column(
            children: [
              Text(
                "Pentru a continua trebuie să te reautentifici",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: provider.validateEmail,
                initialValue: provider.email,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor
                ),
                onChanged: provider.updateEmail,
              ),
              SizedBox(height: 20,),
              TextFormField(
                validator: provider.validatePassword,
                initialValue: provider.password,
                style: Theme.of(context).textTheme.labelMedium,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor
                ),
                onChanged: provider.updatePassword
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: Theme.of(context).textButtonTheme.style!.copyWith(
                        side: MaterialStatePropertyAll(BorderSide(width: 1, color: Theme.of(context).primaryColor)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), )),
                        backgroundColor: MaterialStatePropertyAll(Theme.of(context).highlightColor)),
                    onPressed: () async{
                      var res = await provider.deleteAccount();
                      if(res)
                        Navigator.pop(context);
                    },
                    child: Text(
                      "Șterge",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(width: 30,),
                  TextButton(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor)),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Renunță"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
);