import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Record>>(
      valueListenable: Hive.box<Record>('record').listenable(),
      builder: (context, record, _) {
        var records = record.values.toList().cast<Record>();
        //var totalcord = record.get('total');
        records.sort((a, b) => a.name.compareTo(b.name));
        return Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, int index) {
                    var recordData = records[index];
                    if (recordData.name == 'total') {
                      return Text(
                          '총..${recordData.playCount}번.. 맞춘문제 ${recordData.correct}개..경험치 ${recordData.highScore.toInt()}..');
                    } else {
                      return Text('${recordData.name}${recordData.playCount}');
                    }
                  }),
              // Text('${totalcord?.name}${totalcord?.playCount}'),
            ));
      },
    );
  }
}
