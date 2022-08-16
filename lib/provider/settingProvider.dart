import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting with ChangeNotifier {
  bool _autoFocus;
  bool _left;

  Setting(this._autoFocus, this._left);

  bool get autoFocus => _autoFocus;
  bool get left => _left;

  setAutoFocus(bool focus) async {
    final prefs = await SharedPreferences.getInstance();
    _autoFocus = focus;
    prefs.setBool('autoFocus', focus);
  }

  void setLeft(bool left) async {
    final prefs = await SharedPreferences.getInstance();
    _left = left;
    prefs.setBool('autoFocus', left);
  }

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('autoFocus') != null) {
      _autoFocus = prefs.getBool('autoFocus')!;
    } else {
      prefs.setBool('autoFocus', false);
    }
    if (prefs.getBool('left') != null) {
      _left = prefs.getBool('left')!;
    } else {
      prefs.setBool('left', false);
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
