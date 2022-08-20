import 'package:do_math/pages/score_page.dart';
import 'package:do_math/pages/stage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  int typeIndex = 0;
  int digitalIndex = 0;

  bool _autoFocus = false;
  bool _isLeftHanded = false;
  //bool _method = true;
  late SharedPreferences _prefs;

  List type = ['+', '-', '×', '÷'];
  double ratio = 6 / 5;

  @override
  void initState() {
    _loadCounter();
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    }

    if (index == 2) {
      showBottomSheet(context);
    }

    // if (_selectedIndex != index) {
    //
    // }
  }

  _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoFocus = _prefs.getBool('autoFocus') ?? false;
      _isLeftHanded = _prefs.getBool('left') ?? false;
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Consumer(
                builder: (context, appModel, child) => Container(
                  height: 230,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '설정 변경 후 앱을 재시작 해주세요',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.blue),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text('완료'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        ScorePage(
          selectedIndex: _selectedIndex,
        ), // ranking page로 변경
        Scaffold(
          resizeToAvoidBottomInset: true, // 키보드 밀려오는거 무시
          // appBar: AppBar(
          //   backgroundColor: _selectedIndex >= 0 ? Theme.of(context).primaryColor : Colors.white,
          //   elevation: 0.0,
          //   toolbarHeight: 0.0, // Hide the AppBar
          // ),
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.account_balance_outlined),
              ),
            ],
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: buildButton(context, '오늘의 문제', 1 / 2),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(child: buildButton(context, '랭킹', 2 / 1)),
                              Expanded(child: buildButton(context, '챌린지', 2 / 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildTypeButton(context, '+', ratio, 0, 30),
                          buildTypeButton(context, '-', ratio, 1, 40),
                          buildTypeButton(context, '×', ratio, 2, 30),
                          buildTypeButton(context, '÷', ratio, 3, 30),
                        ],
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildDigitalButton(context, '한 자리 수', ratio, 15, 0),
                        buildDigitalButton(context, '두 자리 수', ratio, 15, 1),
                        buildDigitalButton(context, '세 자리 수', ratio, 15, 2),
                        buildDigitalButton(context, '네 자리 수', ratio, 15, 3),
                      ],
                    ),
                  ),
                  Expanded(flex: 4, child: buildButton(context, '시작', 2 / 1, 50, type[typeIndex])),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: BottomNavigationBar(
              iconSize: 23,
              items: <BottomNavigationBarItem>[
                buildBottomNavigationBarItem(icon: const Icon(Icons.leaderboard), label: 'home'),
                buildBottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: 'storage'),
                buildBottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'write'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColorDark,
              unselectedItemColor: Colors.black26,
              selectedFontSize: 3.0,
              unselectedFontSize: 3.0,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.0),
              //landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
            ),
          ),
        ),
        //ScorePage(),
      ],
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem({Icon? icon, String? label}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
      label: '',
    );
  }

  Widget buildTypeButton(
    context,
    String title,
    double ratio,
    int index, [
    double textSize = 30,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ElevatedButton(
          onPressed: () {
            typeIndex = index;
            setState(() {});
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: textSize,
              //fontSize: (typeIndex == index) ? textSize : 30,
              color: (typeIndex == index) ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDigitalButton(context, String title, double ratio,
      [double textSize = 15, int index = 0]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ElevatedButton(
          onPressed: () {
            digitalIndex = index;
            setState(() {});
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: (digitalIndex == index) ? textSize : 15,
              color: (digitalIndex == index) ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(context, String title, double ratio,
      [double textSize = 20, String type = '+']) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ElevatedButton(
          onPressed: () {
            //await으로 맞춘개수, 걸린 시간, 문제 유형 받아와서 기록.
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StagePage(
                          type: type,
                          digital: digitalIndex + 1,
                        )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: textSize),
          ),
        ),
      ),
    );
  }
}
