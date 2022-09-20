import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting with ChangeNotifier {
  bool _autoFocus;
  bool _left;
  double _timeLimit;

  Setting(this._autoFocus, this._left, this._timeLimit);

  bool getAutoFocus() => _autoFocus;
  bool getLeft() => _left;
  double getTimeLimit() => _timeLimit;

  setAutoFocus(bool focus) async {
    final prefs = await SharedPreferences.getInstance();
    _autoFocus = focus;
    prefs.setBool('autoFocus', focus);
  }

  setTimeLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();
    _timeLimit = limit;
    prefs.setDouble('timeLimit', limit);
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
    if (prefs.getDouble('timeLimit') != null) {
      _timeLimit = prefs.getDouble('timeLimit')!;
    } else {
      prefs.setDouble('timeLimit', 10.0);
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
