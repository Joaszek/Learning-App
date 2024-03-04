import 'package:flutter/material.dart';
import 'package:learningapp/model/Word.dart';

class WordProvider extends ChangeNotifier {
  final List<Word> _words = [];

  List<Word> get words => _words;

  void addWord(Word word) {
    _words.add(word);
    notifyListeners();
  }

  void updateWord(int index, Word word) {
    _words[index] = word;
    notifyListeners();
  }

  void removeWord(int index) {
    _words.removeAt(index);
    notifyListeners();
  }
}
