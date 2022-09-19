import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

Widget CustomListTile(Record recordData) {
  var percent = 10 * (recordData.correct / recordData.playCount);
  List koreanNumber = ['한', '두', '세', '네'];
  String type = recordData.name[0];
  String second = koreanNumber[int.parse(recordData.name[5]) - 1];
  String first = koreanNumber[int.parse(recordData.name[2]) - 1];

  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${first}자릿수 ${type} ${second}자릿수  ',
                style: TextStyle(fontSize: 20),
              ),
              Text('시도 : ${recordData.playCount} / 정답률 : ${percent.toInt()}% / 최고'
                  ' 기록 : ${recordData.highScore}s')
            ],
          ),
        ),
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
          var records = record.values.toList().cast<Record>();
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
                        return CustomListTile(recordData);
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
