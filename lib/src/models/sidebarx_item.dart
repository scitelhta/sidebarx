import 'package:flutter/cupertino.dart';

class SidebarXItem {
  const SidebarXItem({
    required this.id,
    this.label,
    this.icon,
    this.iconr,
    this.iconWidget,
    this.iconText,
    this.iconSize,
    this.height,
    this.heightselected,
    this.padding,
    this.decoration,
    this.decorationselected,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.children
  }) : assert(
          (icon != null || iconWidget != null || iconText != null) &&
              (icon == null || iconWidget == null || iconText == null),
          'You can create SidebarXItem with IconData? icon or with Widget? iconWidget',
        );

  final String id;
  final String? label;
  final IconData? icon;
  final Widget ?iconr;
  final Widget? iconWidget;
  final String ?iconText;
  final double ?iconSize;
  final double ?height;
  final double ?heightselected;
  final EdgeInsets? padding;
  final BoxDecoration?decoration;
  final BoxDecoration?decorationselected;
  final Function()? onTap;
  final Function()? onLongPress;
  final Function()? onSecondaryTap;
  final List<SidebarXItem> ?children;
}
