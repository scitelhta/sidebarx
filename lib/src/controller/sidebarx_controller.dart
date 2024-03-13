import 'dart:async';

import 'package:flutter/material.dart';

class SidebarXController extends ChangeNotifier {
  SidebarXController({
    required int selectedIndex,
     int ?selectedSIndex,
    bool? extended,
  }) : _selectedIndex = selectedIndex, _selectedSIndex = selectedSIndex {
    _setExtended(extended ?? false);
  }

  int _selectedIndex;
  int ?_selectedSIndex;
  var _extended = false;

  final _extendedController = StreamController<bool>.broadcast();
  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  int get selectedIndex => _selectedIndex;
  int? get selectedSIndex => _selectedSIndex;
  void selectIndex(int val) {
    _selectedIndex = val;
    notifyListeners();
  }
  void selectSIndex(int val) {
    _selectedSIndex = val;
    notifyListeners();
  }

  bool get extended => _extended;
  void setExtended(bool extended) {
    _extended = extended;
    _extendedController.add(extended);
    notifyListeners();
  }

  void toggleExtended() {
    _extended = !_extended;
    _extendedController.add(_extended);
    notifyListeners();
  }

  void _setExtended(bool val) {
    _extended = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _extendedController.close();
    super.dispose();
  }
}
