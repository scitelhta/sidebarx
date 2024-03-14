import 'dart:async';

import 'package:flutter/material.dart';

class SidebarXController extends ChangeNotifier {
  SidebarXController({
     String ?selectedI,
     String ?selectedS,
    bool? extended,open
  }) : _selectedI = selectedI, _selectedS = selectedS {
    _setExtended(extended ?? false);
  }

  String ?_selectedI;
  String ?_selectedS;
  var _extended = false;

  final _extendedController = StreamController<bool>.broadcast();
  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  String ? get selectedI => _selectedI;
  String? get selectedS => _selectedS;
  void selectI(String val) {
    _selectedI = val;
    notifyListeners();
  }
  void selectS(String val) {
    _selectedS = val;
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
