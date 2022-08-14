//한 자리 수 덧셈
import 'dart:math';

class PlusQuestion {
  int digital;
  int count;
  PlusQuestion({required this.digital, required this.count});

  List<int> getQuestion() {
    var rng = Random();

    List<int> num1 = List.generate(
        count,
        (_) =>
            rng.nextInt(((pow(10, digital) - pow(10, digital - 1)).toInt())) +
            pow(10, digital - 1).toInt());
    return num1;
  }
}
