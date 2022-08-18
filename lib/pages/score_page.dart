import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  int selectedIndex;

  ScorePage({required this.selectedIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('hi'),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: BottomNavigationBar(
            iconSize: 23,
            items: <BottomNavigationBarItem>[
              buildBottomNavigationBarItem(icon: const Icon(Icons.leaderboard), label: 'home'),
              buildBottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: 'storage'),
              buildBottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'write'),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Theme.of(context).primaryColorDark,
            unselectedItemColor: Colors.black26,
            selectedFontSize: 3.0,
            unselectedFontSize: 3.0,
            //onTap: ,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.0),
            //landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          ),
        ));
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
}
