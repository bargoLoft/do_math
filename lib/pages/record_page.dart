import 'package:do_math/models/record.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Record>('record').listenable(),
        builder: (context, record, _) {
          return Center(
            child: Column(
              children: [Text('hi')],
            ),
          );
        });
  }
}
