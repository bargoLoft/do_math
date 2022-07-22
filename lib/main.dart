import 'package:flutter/material.dart';
import 'package:do_math/pages/home_page.dart';

void main() {
  runApp(const MyApp());
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
