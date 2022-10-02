import 'package:do_math/models/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/fl_chart.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

Widget CustomText(String text) {
  return Text(
    text,
    textAlign: TextAlign.end,
  );
}

Widget CustomListTile(BuildContext context, Record recordData) {
  var percent = 10 * (recordData.correct / recordData.playCount);
  List koreanNumber = ['한자릿수', '두자릿수', '세자릿수', '네자릿수'];
  String type = recordData.name[0];
  int f = int.parse(recordData.name[2]);
  int s = int.parse(recordData.name[5]);
  String second = koreanNumber[s - 1];
  String first = koreanNumber[f - 1];

  Color medalColor({required String name, required double highScore}) {
    List<Color> medalColor = [
      const Color(0xffFFD700),
      const Color(0xffA3A3A3),
      const Color(0xffCD7F32)
    ];
    double defaultTime = 4;
    if (name[0] == '+' || name[0] == '-') {
      defaultTime += 2 * (int.parse(name[2]) + int.parse(name[5]));
    }

    if (name[0] == '×' || name[0] == '÷') {
      defaultTime += 4;
      defaultTime *= int.parse(name[2]) + int.parse(name[5]) - 1;
    }

    if (highScore < defaultTime) {
      return medalColor[0];
    } else if (highScore < defaultTime + 2) {
      return medalColor[1];
    } else if (highScore < defaultTime + 4) {
      return medalColor[2];
    } else {
      return Colors.transparent;
    }
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
            trailing: Icon(
              FontAwesomeIcons.medal,
              color: medalColor(name: recordData.name, highScore: recordData.highScore),
            ),
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'NanumSquare',
                  ),
                  children: [
                    TextSpan(
                        text: first.substring(0, f),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: first.substring(f, 4), style: const TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: ' $type ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: second.substring(0, s),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: second.substring(s, 4), style: const TextStyle(color: Colors.grey)),
                  ]),
            ),
            subtitle: Text('| 시도 : ${recordData.playCount.toString().padLeft(3)} | 정답률 : '
                '${percent.toInt().toString().padLeft(3)}% |'
                ' 최고'
                ' 기록 : ${recordData.highScore.toString().padLeft(5)}s |'),
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('최근 5게임 기록'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BarChartSample3(last10: recordData.last10Score ?? [0, 0, 0, 0, 0]),
              ),
            ]),
      ),
    ),
  );
}

class _RecordPageState extends State<RecordPage> {
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Record>>(
      valueListenable: Hive.box<Record>('record').listenable(),
      builder: (context, record, _) {
        List<Record> records = record.values.toList().cast<Record>();
        records.removeWhere((record) => record.name == 'total');
        records.sort((a, b) => a.name.compareTo(b.name));
        if (groupValue == 1) {
          records.sort((a, b) => a.highScore.compareTo(b.highScore));
        } else if (groupValue == 0) {
          records.sort((a, b) => (a.name[2] + a.name[5]).compareTo(b.name[2] + b.name[5]));
        }
        if (records.isEmpty) {
          return const Center(
            child: Text('아직 진행 내역이 없습니다'),
          );
        } else {
          return Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CupertinoSlidingSegmentedControl(
                      padding: const EdgeInsets.all(4),
                      groupValue: groupValue,
                      children: const {
                        0: Icon(FontAwesomeIcons.arrowDown19),
                        1: Icon(FontAwesomeIcons.clock),
                        2: Icon(
                          Icons.calculate_outlined,
                          size: 30,
                        ),
                      },
                      onValueChanged: (groupValue) {
                        setState(() {
                          this.groupValue = groupValue as int?;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                            //physics: const ClampingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, int index) {
                              var recordData = records[index];
                              if (recordData.name != 'total') {
                                return CustomListTile(context, recordData);
                              } else {
                                return const SizedBox(height: 0); // Total 때문에
                              }
                            }),
                      ),
                    ),
                  ),
                ],
              ));
        }
      },
    );
  }
}
