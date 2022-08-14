import 'package:do_math/pages/stage_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  int typeIndex = 0;
  List type = ['+', '-', '×', '÷'];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        Text('hi'),
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
                          buildTypeButton(context, '+', 1 / 1, 0, 40),
                          buildTypeButton(context, '-', 1 / 1, 1, 40),
                          buildTypeButton(context, '×', 1 / 1, 2, 40),
                          buildTypeButton(context, '÷', 1 / 1, 3, 40),
                        ],
                      )),
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
    double textSize = 20,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ElevatedButton(
          onPressed: () {
            typeIndex = index;
            setState(() {});
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: (typeIndex == index) ? textSize : 20,
              color: (typeIndex == index) ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildButton(context, String title, double ratio, [double textSize = 20, String type = '+']) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: AspectRatio(
      aspectRatio: ratio,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StagePage(
                        type: type,
                      )));
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: textSize),
        ),
      ),
    ),
  );
}
