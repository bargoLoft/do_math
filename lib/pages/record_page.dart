import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

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
  return ExpansionTile(
    //expandedAlignment: Alignment.bottomCenter,
    //expandedCrossAxisAlignment: CrossAxisAlignment.start,
    title: Text(recordData.name),
    children: [
      ListTile(title: CustomText(recordData.playCount.toString())),
      ListTile(title: CustomText(recordData.correct.toString())),
      ListTile(title: CustomText(percent.toString())),
      ListTile(title: CustomText(recordData.highScore.toString())),
    ],
  );
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
          return Align(
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, int index) {
                    var recordData = records[index];
                    var percent = 10 * (recordData.correct / recordData.playCount);
                    return CustomListTile(recordData);
                    if (recordData.name == 'total') {
                      return Text(
                          '총..${recordData.playCount}번.. 맞춘문제 ${recordData.correct}개..경험치 ${recordData.highScore.toInt()}..');
                    } else {
                      return Text(
                          '${recordData.name} / 시도 : ${recordData.playCount} / 정답률 : ${percent.toInt()}% / 최고 기록 : ${recordData.highScore}s');
                    }
                  }));
        },
      ),
    );
  }
}
