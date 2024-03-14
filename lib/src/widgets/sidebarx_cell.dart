import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'circlebutton.dart';

class SidebarXCell extends StatefulWidget {
  const SidebarXCell({
    Key? key,
    required this.item,
    required this.extended,
    required this.selected,
    required this.theme,
    required this.onTap,
    required this.onLongPress,
    required this.onSecondaryTap,
    required this.animationController,
  }) : super(key: key);

  final bool extended;
  final bool selected;
  final SidebarXItem item;
  final SidebarXTheme theme;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSecondaryTap;
  final AnimationController animationController;

  @override
  State<SidebarXCell> createState() => _SidebarXCellState();
}

class _SidebarXCellState extends State<SidebarXCell> {
  late Animation<double> _animation;
  var _hovered = false;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final iconTheme =
        widget.selected ? theme.selectedIconTheme : theme.iconTheme;
    final textStyle = widget.selected
        ? theme.selectedTextStyle
        : (_hovered)
            ? theme.hoverTextStyle
            : theme.textStyle;
    final decoration =
        (widget.selected ? (widget.item.decorationselected??theme.selectedItemDecoration) : (widget.item.decoration??theme.decoration));
    final margin =
        (widget.selected ? theme.selectedItemMargin : theme.itemMargin);
    final padding =
    widget.item.padding??
        (widget.selected ? theme.selectedItemPadding : theme.itemPadding);
    final textPadding =
        widget.selected ? theme.selectedItemTextPadding : theme.itemTextPadding;

    return MouseRegion(
      onEnter: (_) => _onEnteredCellZone(),
      onExit: (_) => _onExitCellZone(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTap: widget.onSecondaryTap,
        behavior: HitTestBehavior.opaque,

        child: Container(
          decoration: decoration?.copyWith(
            color: _hovered && !widget.selected ? theme.hoverColor : null,
          ),
          padding: padding ?? const EdgeInsets.all(8),
          margin: margin ?? const EdgeInsets.all(4),
          height:
          (widget.selected ? widget.item.heightselected : widget.item.height) ??60,
          child:Stack(
              children: [Row(
            mainAxisAlignment: widget.extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  final value = ((1 - _animation.value) * 6).toInt();
                  if (value <= 0) {
                    return const SizedBox();
                  }
                  return Spacer(flex: value);
                },
              ),
              if (widget.item.icon != null)
                _Icon(item: widget.item, iconTheme: iconTheme)
              else if (widget.item.iconWidget != null)
                widget.item.iconWidget!
              else if (widget.item.iconText != null)
                Text(widget.item.iconText!,    style: textStyle,),
              Flexible(
                flex: 6,
                child: FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: textPadding ?? EdgeInsets.zero,
                    child: Text(
                      widget.item.label ?? '',
                      style: textStyle,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

            ],

          ),

                if (widget.item.iconr != null)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top:(_hovered?0:-40),
                    right:0,
                    child: AnimatedOpacity(
                      opacity: (_hovered?1:0),
                      duration: const Duration(milliseconds: 500),
                      child: CircleButton(
                        size:widget.item.iconSize??30,
                        backgroundColor: widget.theme.textStyle?.color?.withAlpha(50),
                        onTap: () {
                          if (widget.onLongPress != null) {
                            widget.onLongPress!();
                          }

                        },
                        child: Container(
                            width:15,
                            height:15,
                            child: widget.item.iconr!),// const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  )
              ]),
        ),
      ),
    );
  }

  void _onEnteredCellZone() {
    debugPrint("si");
    setState(() => _hovered = true);
  }

  void _onExitCellZone() {
    debugPrint("no");
    setState(() => _hovered = false);
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key? key,
    required this.item,
    required this.iconTheme,
  }) : super(key: key);

  final SidebarXItem item;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      item.icon,
      color: iconTheme?.color,
      size: iconTheme?.size,
    );
  }
}
