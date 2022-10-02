import 'package:flutter/cupertino.dart';

//const limitTime = 11; // seconds
const textSize = 15.0;
const iconSize = 25.0;
const version = '1.0.0';
const stageTextStyle = TextStyle(fontSize: 48, letterSpacing: 1);
const questionNumber = 10;

class Challenge {
  String type;
  int index1;
  int index2;
  Challenge(this.type, this.index1, this.index2);
}

List<Challenge> challenges = [
  Challenge('+', 1, 1),
  Challenge('-', 1, 1),
  Challenge('×', 1, 1),
  Challenge('÷', 1, 1),
  Challenge('+', 2, 1),
  Challenge('-', 2, 1),
  Challenge('+', 2, 2),
  Challenge('-', 2, 2),
  Challenge('+', 3, 2),
  Challenge('-', 3, 2),
  Challenge('+', 3, 3),
  Challenge('-', 3, 3),
  Challenge('×', 2, 1),
  Challenge('÷', 2, 1),
  Challenge('+', 4, 3),
  Challenge('-', 4, 3),
  Challenge('+', 4, 4),
  Challenge('-', 4, 4),
  Challenge('×', 2, 2),
  Challenge('÷', 2, 2),
];
