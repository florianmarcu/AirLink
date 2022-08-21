import 'package:flutter/material.dart';
import 'package:transportation_app/common_widgets/app_drawer.dart';
import 'package:transportation_app/screens/wrapper_home/wrapper_home_provider.dart';

class WrapperHomePage extends StatelessWidget {

  // BuildContext context;

  // WrapperHomePage(this.context);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperHomePageProvider>();
    var selectedScreenIndex = provider.selectedScreenIndex; 
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        // key: ,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedScreenIndex,
        items: provider.screenLabels,
        // onTap: (index) => provider.updateSelectedScreenIndex(index),
        onTap: (index) =>
        provider.updateSelectedScreenIndex(index)
        //provider.pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn),

      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, ),
          child: Text(provider.screenLabels[selectedScreenIndex].label!,)
        ),
      ),
      drawer: AppDrawer(),
      /// Added for orders
      // body: Center(
      //   child: IndexedStack(
      //     children: provider.screens,
      //     index: selectedScreenIndex
      //   )
      // ),
      // body: provider.screens[selectedScreenIndex],
      body: IndexedStack(
        children: provider.screens,
        index: provider.selectedScreenIndex,
      )
    );
  }
}