import 'package:flutter/material.dart';

class SwitchProvider extends ChangeNotifier {
  bool _switchMode = false;
  
  bool get switchMode => _switchMode;

  void toggleMode() {
    _switchMode = !_switchMode;
    notifyListeners();
  }

  void setMode(bool value) {
    _switchMode = value;
    notifyListeners();
  }
}