import 'package:do_math/provider/settingProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _autoFocus = false;
  bool _isLeftHanded = false;
  //bool _method = true;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    //context.read<AppModel>().loadSharedPrefs();
    _loadCounter();
  }

  _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoFocus = _prefs.getBool('autoFocus') ?? false;
      //_method = _prefs.getBool('method') ?? true;
      _isLeftHanded = _prefs.getBool('left') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Setting>(
      builder: (context, setting, child) => Scaffold(
          appBar: AppBar(
            title: const Text('설정'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '앱 시작시 바로 검색',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    CupertinoSwitch(
                      value: _autoFocus,
                      onChanged: <bool>(value) {
                        setState(() {
                          _autoFocus = value;
                          _prefs.setBool('autoFocus', _autoFocus);
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '왼손잡이입니까?',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    CupertinoSwitch(
                      value: _isLeftHanded,
                      onChanged: <bool>(value) {
                        setState(() {
                          _isLeftHanded = value;
                          _prefs.setBool('left', _isLeftHanded);
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    // CupertinoSlidingSegmentedControl(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    //   groupValue: _isLeftHanded,
                    //   children: const {
                    //     true: Text(' 네 '),
                    //     false: Text('아니요'),
                    //   },
                    //   onValueChanged: <bool>(newValue) {
                    //     setState(() {
                    //       _isLeftHanded = newValue;
                    //       _prefs.setBool('left', _isLeftHanded);
                    //     });
                    //   },
                    //   thumbColor: Theme.of(context).primaryColorLight,
                    // ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
