import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting with ChangeNotifier {
  bool _autoFocus;
  bool _left;
  bool _rtl;
  double _timeLimit;
  int _challengeStage;
  String _nickname;
  int _id;

  Setting(this._autoFocus, this._left, this._rtl, this._timeLimit, this._challengeStage,
      this._nickname, this._id);

  bool getAutoFocus() => _autoFocus;
  bool getLeft() => _left;
  bool getRtL() => _rtl;
  double getTimeLimit() => _timeLimit;
  int getChallengeStage() => _challengeStage;
  String getNickName() => _nickname;
  int getId() => _id;

  void setAutoFocus(bool focus) async {
    final prefs = await SharedPreferences.getInstance();
    _autoFocus = focus;
    prefs.setBool('autoFocus', focus);
  }

  void setLeft(bool left) async {
    final prefs = await SharedPreferences.getInstance();
    _left = left;
    prefs.setBool('left', left);
  }

  void setRtL(bool rtl) async {
    final prefs = await SharedPreferences.getInstance();
    _rtl = rtl;
    prefs.setBool('rtl', rtl);
  }

  void setTimeLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();
    _timeLimit = limit;
    prefs.setDouble('timeLimit', limit);
  }

  void setChallengeStage(int challenge) async {
    final prefs = await SharedPreferences.getInstance();
    _challengeStage = challenge;
    prefs.setInt('challenge', challenge);
  }

  void setNickName(String nickName) async {
    final prefs = await SharedPreferences.getInstance();
    _nickname = nickName;
    prefs.setString('nickName', nickName);
  }

  void setId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    _id = id;
    prefs.setInt('id', id);
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
    if (prefs.getBool('rtl') != null) {
      _rtl = prefs.getBool('rtl')!;
    } else {
      prefs.setBool('rtl', false);
    }
    if (prefs.getDouble('timeLimit') != null) {
      _timeLimit = prefs.getDouble('timeLimit')!;
    } else {
      prefs.setDouble('timeLimit', 10.0);
    }
    if (prefs.getInt('challenge') != null) {
      _challengeStage = prefs.getInt('challenge')!;
    } else {
      prefs.setInt('challenge', 0);
    }
    if (prefs.getInt('nickName') != null) {
      _nickname = prefs.getString('nickName')!;
    } else {
      prefs.setString('nickName', '');
    }
    if (prefs.getInt('id') != null) {
      _id = prefs.getInt('id')!;
    } else {
      prefs.setInt('id', 0);
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
