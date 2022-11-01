import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(width: 30,child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,))
      ),
    );
  }
}