import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecordPage extends StatelessWidget {
  int selectedIndex;

  RecordPage({required this.selectedIndex, Key? key}) : super(key: key);

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      selectedIndex = index;
    }

    if (index == 2) {
      //showBottomSheet(context);
    }

    // if (_selectedIndex != index) {
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenable Builder로 Hive값 받아오기.
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Record>('record').listenable(),
            builder: (context, record, _) {
              return Center(
                child: Column(
                  children: [Text('hi')],
                ),
              );
            }),
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
