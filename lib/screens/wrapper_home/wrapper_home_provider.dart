import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportation_app/models/models.dart';
import 'package:transportation_app/screens/home/home_page.dart';
import 'package:transportation_app/screens/home/home_provider.dart';
import 'package:transportation_app/screens/profile/profile_page.dart';
import 'package:transportation_app/screens/profile/profile_provider.dart';
export 'package:provider/provider.dart';

class WrapperHomePageProvider with ChangeNotifier{
  BuildContext context;
  int selectedScreenIndex = 0;
  UserProfile? currentUser; 
  bool isLoading = false;
  List<Widget> screens = [];

  List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Acasă",
      icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: "Profil",
      icon: Icon(Icons.person)
    ),
  ];

  WrapperHomePageProvider(this.context){
    getData(context);

  }

  Future<void> getData(BuildContext context) async{
    _loading();

    currentUser = await userToUserProfile(context.read<User?>());

    screens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(),
        builder: (context, _) {
          return HomePage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];

    _loading();

    notifyListeners();
  }

  void updateSelectedScreenIndex(int index){
    selectedScreenIndex = index;

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}