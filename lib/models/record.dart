import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 1)
class Record extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int playCount;

  @HiveField(2)
  int correct;

  @HiveField(3)
  double highScore;

  @HiveField(4)
  List<double>? last10Score;

  Record(this.name, this.playCount, this.correct, this.highScore, this.last10Score);
}
