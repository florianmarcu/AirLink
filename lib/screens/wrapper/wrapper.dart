import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportation_app/common_widgets/loading.dart';
import 'package:transportation_app/screens/authentication/authentication_page.dart';
import 'package:transportation_app/screens/authentication/authentication_provider.dart';
import 'package:transportation_app/screens/onboarding/onboarding_page.dart';
import 'package:transportation_app/screens/onboarding/onboarding_provider.dart';
import 'package:transportation_app/screens/wrapper/wrapper_provider.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_page.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperProvider>();
    var user = Provider.of<User?>(context);
    if(provider.isLoading){ /// loading
      return Container(
        color: Theme.of(context).canvasColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          // alignment: Alignment.bottomCenter,
          // height: 5,
          // width: MediaQuery.of(context).size.width,
          child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
        ), 
      );
    }
    else if(user == null){
      /// Onboarding Screen
      return new FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (!snapshot.hasError) {
                return snapshot.data!.getBool("welcome") != null
                    ? ChangeNotifierProvider(
                      create: (context) => AuthenticationPageProvider(),
                      child: AuthenticationPage()
                    )
                    : MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (context) => OnboardingPageProvider(),),
                          ChangeNotifierProvider.value(value: provider)
                        ],
                        child: OnboardingPage()
                    );
              } else {
                return ChangeNotifierProvider(
                  create: (context) => AuthenticationPageProvider(),
                  child: AuthenticationPage()
                );
              }
          }
        },
      );
    }
    else return ChangeNotifierProvider(
      create: (context) => WrapperHomePageProvider(context),
      //lazy: false,
      child: WrapperHomePage()
    );
  }
}