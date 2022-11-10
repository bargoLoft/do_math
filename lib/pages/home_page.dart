import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_math/pages/ranking_page.dart';
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
import '../provider/settingProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class SliderController {
  double sliderValue;
  SliderController(this.sliderValue);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  DateTime? currentBackPressTime;

  int typeIndex = 0;
  int digitalIndex_1 = 0;
  int digitalIndex_2 = 0;

  bool _autoFocus = false;
  bool _isLeftHanded = false;
  bool _isRtL = false;
  //bool _method = true;
  late SharedPreferences _prefs;

  List type = ['+', '-', '×', '÷'];
  List koreanCount = ['', '한자릿수', '두자릿수', '세자릿수', '네자릿수'];
  double ratio = 6 / 5;

  @override
  void initState() {
    _loadCounter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<Setting>(context, listen: false).getNickName() == '') {
        _login();
      }
    });

    super.initState();
  }

  void _login() {
    CollectionReference usersProduct = FirebaseFirestore.instance.collection('users');
    CollectionReference countProduct = FirebaseFirestore.instance.collection('count');
    TextEditingController nameController = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //icon: const Icon(FontAwesomeIcons.pencil),
            content: Text('닉네임을 입력하시오'),
            actions: [
              TextField(
                textAlign: TextAlign.center,
                controller: nameController,
                decoration: const InputDecoration.collapsed(hintText: '2글자 이상 한글만 가능합니다'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  foregroundColor: Theme.of(context).primaryColorDark,
                ),
                onPressed: () async {
                  if (nameController.text != '' &&
                      nameController.text.length >= 2 &&
                      nameController.text.length <= 8) {
                    final String name = nameController.text;
                    var count = await countProduct.doc('IQyr8ylH1NPSabBotOpW').get();
                    int count1 = count['count'];
                    await usersProduct
                        .doc(count1.toString())
                        .set({'name': name, 'exp': 0, 'id': count1});
                    countProduct.doc('IQyr8ylH1NPSabBotOpW').update({'count': count1 + 1});
                    Provider.of<Setting>(context, listen: false).setNickName(name);
                    Provider.of<Setting>(context, listen: false).setId(count1);
                    nameController.text = '';
                    Navigator.pop(context);
                  } else {
                    SnackBar(
                      content: Text('입력해주세요'),
                    );
                  }
                },
                child: const Center(child: Text('확인')),
              )
            ],
          );
        });
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
      _isRtL = _prefs.getBool('rtl') ?? false;
    });
  }

  void showBottomSheet(BuildContext context) {
    _autoFocus = Provider.of<Setting>(context, listen: false).getAutoFocus();
    _isLeftHanded = Provider.of<Setting>(context, listen: false).getLeft();
    _isRtL = Provider.of<Setting>(context, listen: false).getRtL();
    SliderController sliderController =
        SliderController(Provider.of<Setting>(context, listen: false).getTimeLimit());

    const double space = 12.0;

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
                  height: 370,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColorDark,
                                  ),
                                ],
                              ),
                              const SizedBox(height: space),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '세로셈 방식',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  CupertinoSwitch(
                                    value: _isLeftHanded,
                                    onChanged: <bool>(value) {
                                      setState(() {
                                        _isLeftHanded = value;
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColorDark,
                                  ),
                                ],
                              ),
                              const SizedBox(height: space),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '       아래쪽부터 입력',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  CupertinoSwitch(
                                    value: _isRtL,
                                    onChanged: <bool>(value) {
                                      setState(() {
                                        _isRtL = value;
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColorDark,
                                  ),
                                ],
                              ),
                              const SizedBox(height: space),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      '제한 시간 조절',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Theme.of(context).primaryColorDark,
                                      thumbColor: Theme.of(context).primaryColorDark,
                                      activeTickMarkColor: Theme.of(context).primaryColorDark,
                                      valueIndicatorColor: Theme.of(context).primaryColorDark,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 10,
                                        disabledThumbRadius: 12,
                                        elevation: 2,
                                      ),
                                      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    ),
                                    child: Slider(
                                        min: 5.0,
                                        max: 50.0,
                                        value: sliderController.sliderValue,
                                        label: sliderController.sliderValue.round().toString(),
                                        divisions: 9,
                                        onChanged: (double newValue) {
                                          setState(() {
                                            sliderController.sliderValue = newValue;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: space),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Positioned(
                              left: 20,
                              child: Text(
                                'hadamath v1.0.4\n2022 bargoLoft',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<Setting>(context, listen: false)
                                      .setTimeLimit(sliderController.sliderValue);
                                  Provider.of<Setting>(context, listen: false)
                                      .setAutoFocus(_autoFocus);
                                  Provider.of<Setting>(context, listen: false).setRtL(_isRtL);
                                  Provider.of<Setting>(context, listen: false)
                                      .setLeft(_isLeftHanded);
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Theme.of(context).primaryColorDark),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColorLight),
                                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                child: const Text('완료'),
                              ),
                            ),
                          ],
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
                          padding: const EdgeInsets.all(20),
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
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: GestureDetector(
              onTap: () {
                showCharacter(context);
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.question_mark_rounded,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          total == null
              ? Text(
                  '${Provider.of<Setting>(context).getNickName()} Lv.0',
                  style: TextStyle(fontSize: 8),
                )
              : Text(
                  Provider.of<Setting>(context).getNickName(),
                  style: TextStyle(fontSize: 8),
                ),
          // : Text(
          //     '${Provider.of<Setting>(context).getNickName()} Lv.${(total.highScore) ~/ 100} ${((total.highScore) % 100).toInt()}%',
          //     style: const TextStyle(fontSize: 8),
          //   ),
        ],
      ),
    );
  }

  void showCharacter(BuildContext context) {
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '캐릭터',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Center(
                                child: Text(
                                  '아직 획득한 캐릭터가 없습니다',
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
                  (typeIndex != 3)
                      ? Expanded(
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
                                  buildDigitalButton(context, koreanCount[1], ratio, textSize, 0),
                                  buildDigitalButton(context, koreanCount[2], ratio, textSize, 1),
                                  buildDigitalButton(context, koreanCount[3], ratio, textSize, 2),
                                  buildDigitalButton(context, koreanCount[4], ratio, textSize, 3),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
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
                  (typeIndex != 3)
                      ? Expanded(
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
                        )
                      : Expanded(
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
                                  buildDigitalButton2(context, koreanCount[1], ratio, textSize, 0),
                                  buildDigitalButton2(context, koreanCount[2], ratio, textSize, 1),
                                  buildDigitalButton2(context, koreanCount[3], ratio, textSize, 2),
                                  buildDigitalButton2(context, koreanCount[4], ratio, textSize, 3),
                                ],
                              ),
                            ),
                          ),
                        ),
                  (typeIndex != 3)
                      ? Expanded(
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
                                  buildDigitalButton2(context, koreanCount[1], ratio, textSize, 0),
                                  buildDigitalButton2(context, koreanCount[2], ratio, textSize, 1),
                                  buildDigitalButton2(context, koreanCount[3], ratio, textSize, 2),
                                  buildDigitalButton2(context, koreanCount[4], ratio, textSize, 3),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
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
                                  buildDigitalButton(context, koreanCount[1], ratio, textSize, 0),
                                  buildDigitalButton(context, koreanCount[2], ratio, textSize, 1),
                                  buildDigitalButton(context, koreanCount[3], ratio, textSize, 2),
                                  buildDigitalButton(context, koreanCount[4], ratio, textSize, 3),
                                ],
                              ),
                            ),
                          ),
                        ),
                  Expanded(flex: 4, child: buildButton(context, '시작', 2 / 1, 40, type[typeIndex])),
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
            buildBottomNavigationBarItem(icon: const Icon(Icons.leaderboard), label: 'record'),
            buildBottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: 'home'),
            buildBottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'setting'),
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
      label: label,
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
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: ElevatedButton(
          onPressed: () {
            typeIndex = index;
            setState(() {});
          },
          style: ButtonStyle(
            // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 0)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: typeIndex == index
                ? MaterialStateProperty.all(Theme.of(context).primaryColorLight)
                : MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
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
        backgroundColor: digitalIndex_1 == index
            ? MaterialStateProperty.all(Theme.of(context).primaryColorLight)
            : MaterialStateProperty.all(Colors.white),
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
        backgroundColor: digitalIndex_2 == index
            ? MaterialStateProperty.all(Theme.of(context).primaryColorLight)
            : MaterialStateProperty.all(Colors.white),
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
                          timeLimit: Provider.of<Setting>(context).getTimeLimit() + 1,
                          isChallenge: false,
                        )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
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
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textSize,
                  height: 1,
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
                          timeLimit: Provider.of<Setting>(context).getTimeLimit(),
                          isChallenge: false,
                        )));
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
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
            int currentChallenge = Provider.of<Setting>(context, listen: false).getChallengeStage();
            if (title == '챌린지') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StagePage(
                            type: challenges[currentChallenge].type,
                            digital: [
                              challenges[currentChallenge].index1,
                              challenges[currentChallenge].index2,
                            ],
                            count: 2,
                            timeLimit:
                                Provider.of<Setting>(context, listen: false).getTimeLimit() + 1,
                            isChallenge: true,
                          )));
            } else if (title == '랭킹') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RankingPage()));
            }
            // Fluttertoast.showToast(
            //   msg: "준비중입니다",
            //   gravity: ToastGravity.BOTTOM,
            //   backgroundColor: Colors.white,
            //   textColor: Theme.of(context).primaryColorDark,
            //   fontSize: 12.0,
            //   toastLength: Toast.LENGTH_LONG,
            //   timeInSecForIosWeb: 1,
            //   webShowClose: false,
            // );
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
            overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
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
              Text(
                title,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 17),
                //style: TextStyle(fontSize: textSize, height: 2, color: Colors.grey.shade300),
              ),
              if (title == '챌린지')
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                      'Level ${(Provider.of<Setting>(context).getChallengeStage() + 1).toString()}'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
