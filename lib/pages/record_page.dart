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
  String type = recordData.name[0];
  String second = recordData.name[5];
  String first = recordData.name[2];

  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${first}자리수 ${type} ${second}자리수  ',
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
        },
      ),
    );
  }
}
