import 'package:do_math/models/record.dart';
import 'package:do_math/provider/questionProvider.dart';
import 'package:do_math/provider/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:do_math/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main에서 비동기 메소드 사용시 필요
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Record>('record');

  //SystemChrome.setPreferredOrierntations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(providers: [
      //ChangeNotifierProvider(create: (context) => QuestionProvider()),
      ChangeNotifierProvider(
          create: (context) => Setting(
                (prefs.getBool('autoFocus')) ?? false,
                (prefs.getBool('left')) ?? false,
              )),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '두수앞',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'NanumSquare'),
      home: const HomePage(title: '두수앞'),
    );
  }
}
