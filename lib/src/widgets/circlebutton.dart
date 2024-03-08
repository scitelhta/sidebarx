import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final Color ?backgroundColor;

  const CircleButton({Key ?key,  this.backgroundColor, required this.onTap, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 30.0;

    return new InkWell(

      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: backgroundColor?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}