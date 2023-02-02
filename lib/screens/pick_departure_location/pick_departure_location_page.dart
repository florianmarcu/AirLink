import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class PickDepartureLocationPage extends StatelessWidget {
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
      ),
      body: SizedBox.expand(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(wrapperHomePageProvider.mainLocation!['location'].latitude, wrapperHomePageProvider.mainLocation!['location'].longitude)
          ),
        ),
      ),
    );
  }
}