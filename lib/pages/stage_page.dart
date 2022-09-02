import 'dart:async';

import 'package:do_math/const/const.dart';
import 'package:do_math/models/record.dart';
import 'package:do_math/problems/algorithm.dart';
import 'package:do_math/widgets/count_down.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../problems/algorithm.dart';

// ignore: must_be_immutable
class StagePage extends StatefulWidget {
  String type;
  int count;
  List digital;

  StagePage({
    required this.type,
    required this.digital,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _countController;

  late List<int> questions;
  String question = '';
  late int answer;
  int currentNumber = 0;
  int currentAnswer = 0;

  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _countController =
        AnimationController(vsync: this, duration: const Duration(seconds: limitTime));
    _countController.addListener(() {
      if (_countController.isCompleted) {
        next(false);
      }
    });
    _countController.forward();
    getNewQuestion();
  }

  @override
  void dispose() {
    if (_countController.isAnimating || _countController.isCompleted) {
      _countController.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) => addTime());
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void refreshStage() {
    currentNumber = 0;
    currentAnswer = 0;
    duration = const Duration(seconds: 0);
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) => addTime());
    getNewQuestion();
    _countController.forward();
    setState(() {});
  }

  Future<void> next(bool oX) async {
    _textController.clear();
    _countController.reset();
    _countController.forward();
    currentNumber += 1;
    if (oX) currentAnswer++;
    if (currentNumber == 10) {
      // 문제 다 풀면.
      _countController.stop();
      timer?.cancel();
      //hive에 결과 저장.
      //횟수는 ++;
      //duratoin 총 시간.(초)
      //currentAnswer 맞은 개수.
      //Hive.registerAdapter(RecordAdapter());
      var box = await Hive.openBox<Record>('record');
      Record? record = box.get(
        '${widget.type}${widget.digital}',
        defaultValue: Record('${widget.type}${widget.digital}', 0, 0, 1000.0),
      );
      Record? totalRecord = box.get(
        'total',
        defaultValue: Record('total', 0, 0, 0),
      );
      totalRecord?.playCount += 1;
      totalRecord?.correct += currentAnswer;
      totalRecord?.highScore += widget.digital.reduce((value, element) => value + element) *
          currentAnswer; // 경험치. 자릿수 총 합 * 맞춘 문제 수

      record?.playCount += 1;
      record?.correct += currentAnswer;
      if (duration.inSeconds / 100 < record!.highScore) {
        record.highScore = duration.inSeconds / 100;
        print(record.highScore);
      }
      box.put('${widget.type}${widget.digital}', record);
      print('${record.name}/${record.playCount}/${record.correct}/${record.highScore}');
      box.put('total', totalRecord!);
      print(
          '${totalRecord.name}/${totalRecord.playCount}/${totalRecord.correct}/${totalRecord.highScore}');
      showResultPopup();
    } else {
      getNewQuestion();
    }
    // modal 팝업으로 기록이랑 다시하기, 나가기, 랭킹 화면 보여주기
    //Navigator.pop(context);
    setState(() {});
  }

  void getNewQuestion() {
    if (widget.type == '+') {
      getPlusQuestion();
    } else if (widget.type == '-') {
      getMinusQuestion();
    } else if (widget.type == '×') {
      getMultiQuestion();
    } else if (widget.type == '÷') {
      getDivideQuestion();
    }
  }

  void getPlusQuestion() {
    questions = PlusQuestion(count: 2, digital: widget.digital).getQuestion();
    question = '';
    for (int i = 0; i < questions.length; i++) {
      question += questions[i].toString();
      if (i != questions.length - 1) {
        question += '+';
      }
      answer = questions.fold(0, (total, element) {
        return total + element;
      });
    }
    print('${questions.toString()} $answer');
  }

  void getMinusQuestion() {
    questions = MinusQuestion(count: 2, digital: widget.digital).getQuestion();
    question = '';
    for (int i = 0; i < questions.length; i++) {
      question += questions[i].toString();
      if (i != questions.length - 1) {
        question += '-';
      }
      answer = questions.fold(questions[0] + questions[0], (total, element) {
        return total - element;
      });
    }
    print('${questions.toString()} $answer');
  }

  void getMultiQuestion() {
    questions = MultiQuestion(count: 2, digital: widget.digital).getQuestion();
    question = '';
    for (int i = 0; i < questions.length; i++) {
      question += questions[i].toString();
      if (i != questions.length - 1) {
        question += '×';
      }
      answer = questions.fold(1, (total, element) {
        return total * element;
      });
    }
    print('${questions.toString()} $answer');
  }

  void getDivideQuestion() {
    questions = DivideQuestion(count: 2, digital: widget.digital).getQuestion();
    question = '';
    for (int i = 0; i < questions.length; i++) {
      question += questions[i].toString();
      if (i != questions.length - 1) {
        question += '÷';
      }
      answer = questions.fold(questions[0] * questions[0], (total, element) {
        return total ~/ element;
      });
    }
    print('${questions.toString()} $answer');
  }

  void showResultPopup() {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.6),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: AspectRatio(
              aspectRatio: 10 / 11,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: currentAnswer.toString(),
                          style: TextStyle(
                            fontSize: 100,
                            color: currentAnswer >= 4 ? Colors.blue : Colors.red,
                          ),
                          children: const [
                            TextSpan(
                                text: '/10',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                      Text('걸린 시간 : ${(duration.inSeconds / 100).toString().padLeft(2, '0')}s'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 40,
                            onPressed: () {
                              _countController.dispose();
                              timer?.cancel();
                              Navigator.pop(context); // pushNamed로 한 번에 가도록 변경
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.home_rounded),
                          ),
                          IconButton(
                            iconSize: 60,
                            onPressed: () {
                              Navigator.pop(context); // pushNamed로 한 번에 가도록 변경
                              refreshStage();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                          IconButton(
                            iconSize: 30,
                            onPressed: () {
                              Navigator.pop(context); // pushNamed로 한 번에 가도록 변경
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.leaderboard_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 2,
                  color: Colors.grey.shade200,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.1 * currentNumber,
                  height: 2,
                  color: Colors.green,
                ),
                Countdown(animation: StepTween(begin: limitTime, end: 0).animate(_countController)),
                Text('${duration.inSeconds}'),
              ],
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      question,
                      style: const TextStyle(fontSize: 40, letterSpacing: 2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '= ',
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(
                        //height: 70,
                        width: answer.toString().length * 30 + 15,
                        child: TextField(
                          enabled: false,
                          controller: _textController,
                          maxLines: 1,
                          //maxLength: answer.toString().length,
                          //textAlign: TextAlign.center,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          //expands: true,
                          //textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            //counterText: '',
                          ),
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Text(
                        ' =',
                        style: TextStyle(fontSize: 40, color: Colors.grey.shade50),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        buildNumber('1'),
                        buildNumber('2'),
                        buildNumber('3'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        buildNumber('4'),
                        buildNumber('5'),
                        buildNumber('6'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        buildNumber('7'),
                        buildNumber('8'),
                        buildNumber('9'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        buildNumber('←'),
                        buildNumber('0'),
                        buildNumber('C'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumber(String num) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (num == '←' && _textController.text.isNotEmpty) {
            _textController.text =
                _textController.text.substring(0, _textController.text.length - 1);
          } else if (num == 'C') {
            _textController.clear();
          } else if (num != '←' && _textController.text.length < answer.toString().length) {
            _textController.text += num;
            if (_textController.text == answer.toString()) {
              next(true);
            }
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * (1 / 3),
          height: MediaQuery.of(context).size.height * (0.11),
          child: Center(
            child: Text(
              num,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
