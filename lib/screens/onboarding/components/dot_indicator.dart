import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {

  final bool isActive;

  DotIndicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20)
      ),
      width: 5,
      height: isActive ? 12 : 5,
    );
  }
}