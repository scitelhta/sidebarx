import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:sidebarx/src/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class SidebarX extends StatefulWidget {
  const SidebarX({
    Key? key,
    required this.controller,
    this.items = const [],
    this.footerItems = const [],
    this.theme = const SidebarXTheme(),
    this.extendedTheme,
    this.headerBuilder,
    this.footerBuilder,
    this.separatorBuilder,
    this.toggleButtonBuilder,
    this.showToggleButton = true,
    this.headerDivider,
    this.footerDivider,
    this.animationDuration = const Duration(milliseconds: 300),
    this.collapseIcon = Icons.arrow_back_ios_new,
    this.extendIcon = Icons.arrow_forward_ios,
  }) : super(key: key);

  /// Default theme of Sidebar
  final SidebarXTheme theme;

  /// Theme of extended sidebar
  /// Using [theme] if [extendedTheme] is null
  final SidebarXTheme? extendedTheme;

  final List<SidebarXItem> items;
  final List<SidebarXItem> footerItems;

  /// Controller to interact with Sidebar from code
  final SidebarXController controller;

  /// Builder for implement custom seporators between [itmes]
  final IndexedWidgetBuilder? separatorBuilder;

  /// Builder for implement your custom Sidebar header
  final SidebarXBuilder? headerBuilder;

  /// Builder for implement your custom Sidebar footer
  final SidebarXBuilder? footerBuilder;

  /// Builder for toggle button at the bottom of the bar
  final SidebarXBuilder? toggleButtonBuilder;

  /// Sidebar showing toggle button if value [true]
  /// not showing if value [false]
  final bool showToggleButton;

  /// Divider between header and [items]
  final Widget? headerDivider;

  /// Divider footer header and [items]
  final Widget? footerDivider;

  /// Togglin animation duration
  final Duration animationDuration;

  ///Collapse Icon
  final IconData collapseIcon;

  ///Extend Icon
  final IconData extendIcon;

  @override
  State<SidebarX> createState() => _SidebarXState();
}

class _SidebarXState extends State<SidebarX>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    if (widget.controller.extended) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
    widget.controller.extendStream.listen(
      (extended) {
        if (_animationController?.isCompleted ?? false) {
          _animationController?.reverse();
        } else {
          _animationController?.forward();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final extendedT = widget.extendedTheme?.mergeWith(widget.theme);
        final selectedTheme = widget.controller.extended
            ? extendedT ?? widget.theme
            : widget.theme;

        final t = selectedTheme.mergeFlutterTheme(context);

        return AnimatedContainer(
          duration: widget.animationDuration,
          width: t.width,
          height: t.height,
          padding: t.padding,
          margin: t.margin,
          decoration: t.decoration,
          child: Column(
            children: [
              widget.headerBuilder?.call(context, widget.controller.extended) ??
                  const SizedBox(),
              widget.headerDivider ?? const SizedBox(),
              Expanded(
                  child:Scaffold
                    (
                    backgroundColor: selectedTheme.decoration?.color,
                    body: CustomScrollView
                      (
                      slivers: [

                        MultiSliver
                          (
                          // defaults to false
                          pushPinnedChildren: true,
                          children:  widget.items.asMap().entries.map((v) {
                            var item = v.value;
                            var index = v.key;
                            //var item = widget.item
                            return [
                            SliverPersistentHeader(
                              pinned: true,
                                delegate: _SliverAppBarDelegate(
                                    minHeight: 50.0,
                                    maxHeight: 120.0,
                                child: SidebarXCell(
                                  item: item,
                                  theme: t,
                                  animationController: _animationController!,
                                  extended: widget.controller.extended,
                                  selected: widget.controller.selectedI == item.id,
                                  onTap: () {

                                    _onItemSelected(item, item.id);
                                    },
                                  onLongPress: () => _onItemLongPressSelected(item, index),
                                  onSecondaryTap: () =>
                                      _onItemSecondaryTapSelected(item, index),
                                )
                            )
                            ),
                            SliverList(

                              delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int iindex) {
                                  //final item = widget.items[index];
                                      final iitem = item.children![iindex];
                                  return SidebarXCell(
                                    item: iitem,
                                    theme: t,
                                    animationController: _animationController!,
                                    extended: widget.controller.extended,
                                    selected: (widget.controller.selectedS == iitem.id) && (widget.controller.selectedI == item.id),
                                    onTap: () {
                                      _onItemSelected(iitem, item.id, sId: iitem.id);
                                    },
                                    onLongPress: () => _onItemLongPressSelected(iitem, index),
                                    onSecondaryTap: () =>
                                        _onItemSecondaryTapSelected(iitem, index),
                                  );

                                },
                                // 40 list items
                                childCount: (item.children??[]).length,
                              ),
                            ),

                          ];
                          },).expand((u)=>u).toList() as List<Widget>,
                        ),
                              ]
                      ),
                    ),
                  ),
                /*   child: ListView.builder(
                  itemCount: widget.items.length,
                  //separatorBuilder: widget.separatorBuilder ??
                   //   (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return SidebarXCell(
                      item: item,
                      theme: t,
                      animationController: _animationController!,
                      extended: widget.controller.extended,
                      selected: widget.controller.selectedIndex == index,
                      onTap: () => _onItemSelected(item, index),
                      onLongPress: () => _onItemLongPressSelected(item, index),
                      onSecondaryTap: () =>
                          _onItemSecondaryTapSelected(item, index),
                    );
                  },
                ),*/

              widget.footerDivider ?? const SizedBox(),
              widget.footerBuilder?.call(context, widget.controller.extended) ??
                  const SizedBox(),
              if (widget.footerItems.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    itemCount: widget.footerItems.length,
                    separatorBuilder: widget.separatorBuilder ??
                        (_, __) => const SizedBox(height: 3),
                    itemBuilder: (context, index) {
                      final item = widget.footerItems.reversed.toList()[index];
                      return SidebarXCell(
                        item: item,
                        theme: t,
                        animationController: _animationController!,
                        extended: widget.controller.extended,
                        selected: false,
                        //widget.controller.selectedIndex ==
                          //  widget.items.length +
                            //    widget.footerItems.length -
                              //  index -
                                //1,
                        onTap: () => _onFooterItemSelected(item, index),
                        onLongPress: () =>
                            _onFooterItemLongPressSelected(item, index),
                        onSecondaryTap: () =>
                            _onFooterItemSecondaryTapSelected(item, index),
                      );
                    },
                  ),
                ),
              if (widget.showToggleButton)
                _buildToggleButton(t, widget.collapseIcon, widget.extendIcon),
            ],
          ),
        );
      },
    );
  }

  void _onFooterItemSelected(SidebarXItem item, int index) {
    item.onTap?.call();
    //widget.controller.selectIndex(
      //  widget.items.length + widget.footerItems.length - index - 1);
  }

  void _onFooterItemLongPressSelected(SidebarXItem item, int index) {
    item.onLongPress?.call();
  }

  void _onFooterItemSecondaryTapSelected(SidebarXItem item, int index) {
    item.onSecondaryTap?.call();
  }

  void _onItemSelected(SidebarXItem item, String iId, {String?sId}) {
    item.onTap?.call();
    widget.controller.selectI(iId);
    if (sId != null) {
      widget.controller.selectS(sId);
    }
  }

  void _onItemLongPressSelected(SidebarXItem item, int index) {
    item.onLongPress?.call();
  }

  void _onItemSecondaryTapSelected(SidebarXItem item, int index) {
    item.onSecondaryTap?.call();
  }

  Widget _buildToggleButton(
    SidebarXTheme sidebarXTheme,
    IconData collapseIcon,
    IconData extendIcon,
  ) {
    final buildedToggleButton =
        widget.toggleButtonBuilder?.call(context, widget.controller.extended);
    if (buildedToggleButton != null) {
      return buildedToggleButton;
    }

    return InkWell(
      key: const Key('sidebarx_toggle_button'),
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        if (_animationController!.isAnimating) return;
        widget.controller.toggleExtended();
      },
      child: Row(
        mainAxisAlignment: widget.controller.extended
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Icon(
              widget.controller.extended ? collapseIcon : extendIcon,
              color: sidebarXTheme.iconTheme?.color,
              size: sidebarXTheme.iconTheme?.size,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }
}
