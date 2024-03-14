import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final Color ?backgroundColor;
  final double size;

  const CircleButton({Key ?key,  this.backgroundColor, required this.onTap, required this.child, this.size=30.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {


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