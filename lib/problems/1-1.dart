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
    // List<int> num2 = List.generate(10, (_) => rng.nextInt((10 ^ digital) - 1) + 1);
    // List<String> question = List.generate(10, (index) => '${num1[index]})+${num2[index]}');
    // List<int> solution = List.generate(10, (index) => num1[index] + num2[index]);
    //
    // Map<String, int> myQuestion = Map();
    // for (int i = 0; i < 10; i++) {
    //   myQuestion[question[i]] = solution[i];
    // }
    return num1;
  }
}
