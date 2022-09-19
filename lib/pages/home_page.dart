import 'package:do_math/pages/record_page.dart';
import 'package:do_math/pages/stage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';
import '../models/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  DateTime? currentBackPressTime;

  int typeIndex = 0;
  int digitalIndex_1 = 0;
  int digitalIndex_2 = 0;

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

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Theme.of(context).primaryColorDark,
        fontSize: 12.0,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        webShowClose: false,
      );
      return false;
    }
    return true;
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        _selectedIndex = index;
      });
    }
    if (index == 2) {
      showBottomSheet(context);
    }
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
            top: Radius.circular(13),
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
                                    '진행 시간 표시',
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
                            foregroundColor:
                                MaterialStateProperty.all(Theme.of(context).primaryColorDark),
                            backgroundColor:
                                MaterialStateProperty.all(Theme.of(context).primaryColorLight),
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

  void showAward(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(13),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Consumer(
                builder: (context, appModel, child) => Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '박물관',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Center(
                                child: Text(
                                  '아직 획득한 뱃지가 없습니다',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () => Navigator.pop(context),
                        //   style: ButtonStyle(
                        //     foregroundColor:
                        //         MaterialStateProperty.all(Theme.of(context).primaryColorDark),
                        //     backgroundColor:
                        //         MaterialStateProperty.all(Theme.of(context).primaryColorLight),
                        //     shadowColor: MaterialStateProperty.all(Colors.transparent),
                        //   ),
                        //   child: const Text('완료'),
                        // )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget imageProfile() {
    var record = Hive.box<Record>('record');
    var total = record.get('total');
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.question_mark_rounded,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          total == null
              ? const Text(
                  'Lv.0',
                  style: TextStyle(fontSize: 8),
                )
              : Text(
                  'Lv.${(total.highScore) ~/ 100} ${((total.highScore) % 100).toInt()}%',
                  style: const TextStyle(fontSize: 8),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: imageProfile(),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showAward(context);
                },
                child: const Icon(Icons.account_balance_outlined)),
          ),
        ],
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const RecordPage(), // ranking page로 변경
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: buildButton2(context, '오늘의 문제', 1 / 2),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(child: buildButton3(context, '랭킹', 2 / 1)),
                              Expanded(child: buildButton3(context, '챌린지', 2 / 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildDigitalButton(context, '한자릿수', ratio, textSize, 0),
                            buildDigitalButton(context, '두자릿수', ratio, textSize, 1),
                            buildDigitalButton(context, '세자릿수', ratio, textSize, 2),
                            buildDigitalButton(context, '네자릿수', ratio, textSize, 3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildTypeButton(context, '+', ratio, 0, iconSize),
                            buildTypeButton(context, '﹣', ratio, 1, iconSize),
                            buildTypeButton(context, '×', ratio, 2, iconSize),
                            buildTypeButton(context, '÷', ratio, 3, iconSize),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildDigitalButton2(context, '한자릿수', ratio, textSize, 0),
                            buildDigitalButton2(context, '두자릿수', ratio, textSize, 1),
                            buildDigitalButton2(context, '세자릿수', ratio, textSize, 2),
                            buildDigitalButton2(context, '네자릿수', ratio, textSize, 3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 4, child: buildButton(context, '시작', 2 / 1, 50, type[typeIndex])),
                ],
              ),
            ),
          ),
          //ScorePage(),
        ],
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
    return ElevatedButton(
      onPressed: () {
        typeIndex = index;
        setState(() {});
      },
      style: ButtonStyle(
        // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 0)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: (typeIndex == index) ? FontWeight.bold : FontWeight.normal,
          //fontSize: (typeIndex == index) ? textSize : 30,
          color: (typeIndex == index) ? Theme.of(context).primaryColorDark : Colors.grey,
        ),
      ),
    );
  }

  Widget buildDigitalButton(context, String title, double ratio,
      [double textSize = 15, int index = 0]) {
    return ElevatedButton(
      onPressed: () {
        digitalIndex_1 = index;
        setState(() {});
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: (digitalIndex_1 >= index) ? FontWeight.bold : FontWeight.normal,
          //fontSize: (digitalIndex_1 == index) ? textSize : 15,
          color: (digitalIndex_1 >= index) ? Theme.of(context).primaryColorDark : Colors.grey,
        ),
      ),
    );
  }

  Widget buildDigitalButton2(context, String title, double ratio,
      [double textSize = 15, int index = 0]) {
    return ElevatedButton(
      onPressed: () {
        digitalIndex_2 = index;
        setState(() {});
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: (digitalIndex_2 >= index) ? FontWeight.bold : FontWeight.normal,
          //fontSize: (digitalIndex_2 == index) ? textSize : 15,
          color: (digitalIndex_2 >= index) ? Theme.of(context).primaryColorDark : Colors.grey,
        ),
      ),
    );
  }

  Widget buildButton(context, String title, double ratio,
      [double textSize = 20, String type = '+']) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
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
                          digital: [digitalIndex_1 + 1, digitalIndex_2 + 1],
                          count: 2,
                        )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
          ),
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(
                Icons.arrow_circle_right_outlined,
                size: 100,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textSize,
                  height: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton2(context, String title, double ratio,
      [double textSize = 20, String type = '+']) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
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
                          digital: [digitalIndex_1 + 1, digitalIndex_2 + 1],
                          count: 2,
                        )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Icon(
                  Icons.calendar_today,
                  size: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textSize),
                ),
              ),
              Text(
                '${DateTime.now().month}월${DateTime.now().day}일',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton3(context, String title, double ratio,
      [double textSize = 20, String type = '+']) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ElevatedButton(
          onPressed: () {
            Fluttertoast.showToast(
              msg: "준비중입니다",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Theme.of(context).primaryColorDark,
              fontSize: 12.0,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 1,
              webShowClose: false,
            );
            //await으로 맞춘개수, 걸린 시간, 문제 유형 받아와서 기록.
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => StagePage(
            //               type: type,
            //               digital: [digitalIndex_1 + 1, digitalIndex_2 + 1],
            //               count: 2,
            //             )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: textSize, height: 2, color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
