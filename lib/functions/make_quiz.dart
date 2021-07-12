import 'dart:math';

import 'package:word_game/data/constants.dart';

class MakeQuiz {
  final _random = new Random();

  //문제 랜덤선택
  String selectQuiz() {
    String words = basicQuizs1[_random.nextInt(basicQuizs1.length)];

    return words;
  }

  Map makeQuiz() {
    String word = selectQuiz();

    Map quiz = new Map();

    for (int i = 0; i < word.length; i++) {
      quiz[i.toString()] = [word[i], true];
    }

    return quiz;
  }

  String getHint(String key) {
    String hint = '';
    for (int i = 0; i < descritions.length; i++) {
      print(descritions[i].keys.first);
      if (descritions[i].keys.first == key) {
        hint = descritions[i][key];
        break;
      }
    }

    return hint;
  }
}
