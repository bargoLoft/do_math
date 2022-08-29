//한 자리 수 덧셈
import 'dart:math';

class PlusQuestion {
  int count;
  List digital;
  PlusQuestion({required this.digital, required this.count});

  List<int> getQuestion() {
    //final question = Provider.of<QuestionProvider>(context);
    var rng = Random();

    List<int> num1 = List.generate(
        count,
        (int i) =>
            rng.nextInt(((pow(10, digital[i]) - pow(10, digital[i] - 1)).toInt())) +
            pow(10, digital[i] - 1).toInt());
    return num1;
  }
}

class MinusQuestion {
  int count;
  List digital;
  MinusQuestion({required this.digital, required this.count});

  List<int> getQuestion() {
    //final question = Provider.of<QuestionProvider>(context);
    var rng = Random();

    List<int> num1 = List.generate(
        count,
        (int i) =>
            rng.nextInt(((pow(10, digital[i]) - pow(10, digital[i] - 1)).toInt())) +
            pow(10, digital[i] - 1).toInt());
    num1.sort();
    return num1.reversed.toList();
  }
}

class MultiQuestion {
  int count;
  List digital;
  MultiQuestion({required this.digital, required this.count});

  List<int> getQuestion() {
    //final question = Provider.of<QuestionProvider>(context);
    var rng = Random();

    List<int> num1 = List.generate(
        count,
        (int i) =>
            rng.nextInt(((pow(10, digital[i]) - pow(10, digital[i] - 1)).toInt())) +
            pow(10, digital[i] - 1).toInt());
    return num1;
  }
}

class DivideQuestion {
  int count;
  List digital;
  DivideQuestion({required this.digital, required this.count});

  List<int> getQuestion() {
    //final question = Provider.of<QuestionProvider>(context);
    var rng = Random();

    List<int> num1 = List.generate(
        count,
        (int i) =>
            rng.nextInt(((pow(10, digital[i]) - pow(10, digital[i] - 1)).toInt())) +
            pow(10, digital[i] - 1).toInt());
    int sum = num1.fold(1, (total, element) => total * element);
    num1.add(sum);
    num1 = num1.reversed.toList();
    num1.removeLast();
    return num1;
  }
}
