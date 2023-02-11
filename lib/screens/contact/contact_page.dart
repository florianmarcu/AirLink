import 'package:flutter/material.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          // onPressed: () => wrapperHomePageProvider.pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.arrow_back_ios),
            //child: Image.asset(localAsset("cancel"),),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text("Contact")),
        ),
      ),
      body: wrapperHomePageProvider.configData != null && wrapperHomePageProvider.configData!['contact_email'] != null
      ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mail),
                SizedBox(width: 15,),
                Text("Email", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18)),
              ],
            ),
            SizedBox(height: 15),
            Text("${wrapperHomePageProvider.configData!['contact_email']}", style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 16))
          ],
        ),
      )
      : Container(),
    );
  }
}