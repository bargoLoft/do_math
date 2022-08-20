//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  Animation<int> animation;

  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    var timerText = '${clockTimer.inMinutes.remainder(60).toString()}:'
        '${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          '${timerText}',
          style: TextStyle(fontSize: 20, color: animation.value > 3 ? Colors.black : Colors.red),
        ),
      ),
    );
  }
}
