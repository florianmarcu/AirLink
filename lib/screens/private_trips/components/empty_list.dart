import 'package:flutter/material.dart';
import 'package:transportation_app/config/config.dart';

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            localAsset("no-data"),
            width: 200,
          ),
          //SizedBox(height: 20,),
          Text(
            "Nu există rezultate pentru câmpurile alese", 
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: 16,
              
              //color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.54)
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}