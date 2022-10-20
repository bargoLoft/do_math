import 'package:do_math/models/record.dart';
import 'package:do_math/provider/settingProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:do_math/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main에서 비동기 메소드 사용시 필요
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Record>('record');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //await Future.delayed(const Duration(seconds: 1)).then((value) => FlutterNativeSplash.remove());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      //ChangeNotifierProvider(create: (context) => QuestionProvider()),
      ChangeNotifierProvider(
          create: (context) => Setting(
                (prefs.getBool('autoFocus')) ?? false,
                (prefs.getBool('left')) ?? false,
                (prefs.getBool('rtl')) ?? false,
                (prefs.getDouble('timeLimit')) ?? 10.0,
                (prefs.getInt('challenge')) ?? 0,
                (prefs.getString('nickName')) ?? '',
              )),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.black,
    //   statusBarIconBrightness: Brightness.dark,
    //   systemNavigationBarColor: Colors.black,
    // ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '두수앞',
      theme: ThemeData(
        fontFamily: 'NanumSquare',
        useMaterial3: true,
        primaryColor: const Color(0x5fa1df6e), // e8ffd2
        primaryColorDark: const Color(0xff0a3711),
        primaryColorLight: const Color(0xfff4ffeb),
      ),
      home: const HomePage(title: '두수앞'),
    );
  }
}
