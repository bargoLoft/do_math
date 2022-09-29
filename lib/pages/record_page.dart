import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  int f = int.parse(recordData.name[5]);
  int s = int.parse(recordData.name[2]);
  String second = koreanNumber[s - 1];
  String first = koreanNumber[f - 1];

  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
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
            subtitle: Text('시도 : ${recordData.playCount} / 정답률 : ${percent.toInt()}% / 최고'
                ' 기록 : ${recordData.highScore}s'),
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
  //   ExpansionTile(
  //   //expandedAlignment: Alignment.bottomCenter,
  //   //expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //   title: Text(recordData.name),
  //   children: [
  //     ListTile(title: CustomText(recordData.playCount.toString())),
  //     ListTile(title: CustomText(recordData.correct.toString())),
  //     ListTile(title: CustomText(percent.toString())),
  //     ListTile(title: CustomText(recordData.highScore.toString())),
  //   ],
  // );
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ValueListenableBuilder<Box<Record>>(
        valueListenable: Hive.box<Record>('record').listenable(),
        builder: (context, record, _) {
          List<Record> records = record.values.toList().cast<Record>();
          //var totalRecord = record.get('total');
          records.sort((a, b) => a.name.compareTo(b.name));
          if (records.isEmpty) {
            return const Center(
              child: Text('아직 진행 내역이 없습니다'),
            );
          } else {
            return Align(
                alignment: Alignment.center,
                child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, int index) {
                      var recordData = records[index];
                      if (recordData.name != 'total') {
                        return CustomListTile(context, recordData);
                      } else {
                        return const SizedBox(height: 0); // Total 때문에
                      }
                      // if (recordData.name == 'total') {
                      //   return Text(
                      //       '총..${recordData.playCount}번.. 맞춘문제 ${recordData.correct}개..경험치 ${recordData.highScore.toInt()}..');
                      // } else {
                      //   return Text(
                      //       '${recordData.name} / 시도 : ${recordData.playCount} / 정답률 : ${percent.toInt()}% / 최고 기록 : ${recordData.highScore}s');
                      // }
                    }));
          }
        },
      ),
    );
  }
}
