import 'package:flutter/cupertino.dart';

class SidebarXItem {
  const SidebarXItem({
    this.label,
    this.icon,
    this.iconr,
    this.iconWidget,
    this.height,
    this.heightselected,
    this.padding,
    this.decoration,
    this.decorationselected,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
  }) : assert(
          (icon != null || iconWidget != null) &&
              (icon == null || iconWidget == null),
          'You can create SidebarXItem with IconData? icon or with Widget? iconWidget',
        );

  final String? label;
  final IconData? icon;
  final Widget ?iconr;
  final Widget? iconWidget;
  final double ?height;
  final double ?heightselected;
  final EdgeInsets? padding;
  final BoxDecoration?decoration;
  final BoxDecoration?decorationselected;
  final Function()? onTap;
  final Function()? onLongPress;
  final Function()? onSecondaryTap;
}
