import 'package:do_math/problems/1-1.dart';
import 'package:flutter/material.dart';
import '../problems/1-1.dart';

class StagePage extends StatefulWidget {
  const StagePage({Key? key}) : super(key: key);

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  final _textController = TextEditingController();
  late List<int> questions;
  late int answer;
  int currentNumber = 0;

  @override
  void initState() {
    super.initState();
    getNewQuestion();
  }

  void getNewQuestion() {
    questions = PlusQuestion(digital: 2, count: 3).getQuestion();
    answer = questions.fold(0, (previousValue, element) {
      return previousValue + element;
    });
    print('${questions.toString()} $answer');
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
                )
              ],
            ),
            Expanded(
              flex: 4,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      questions.toString(),
                      style: TextStyle(fontSize: 40),
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
                        height: 60,
                        width: 150,
                        child: TextField(
                          // onChanged: (index) {
                          //   if (index == answer.toString()) {
                          //     setState(() {
                          //       getNewQuestion();
                          //     });
                          //   }
                          // },
                          enabled: false,
                          controller: _textController,
                          maxLines: 1,
                          //textAlign: TextAlign.center,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          //expands: true,
                          //textCapitalization: TextCapitalization.words,
                          //maxLength: 10,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
              )),
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
          } else if (num != '←') {
            _textController.text += num;
            if (_textController.text == answer.toString()) {
              getNewQuestion();
              _textController.clear();
              currentNumber += 1;
            }
          }
          setState(() {});
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
