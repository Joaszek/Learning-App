import 'package:flutter/material.dart';
import '../model/word.dart';
import '../database_helper.dart';
import 'main_page.dart';

class QuizPage extends StatefulWidget {
  final List<Word> words;
  DatabaseHelper dbHelper = DatabaseHelper();

  QuizPage({super.key, required this.words, required this.dbHelper});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _controller = TextEditingController();
  int _currentIndex = 0;
  bool _isCorrect = false;

  void _checkAnswer() {
    setState(() {
      Word currentWord = widget.words[_currentIndex];
      String userAnswer = _controller.text.trim();
      _isCorrect = (currentWord.english == userAnswer &&
              currentWord.korean.isNotEmpty) ||
          (currentWord.korean == userAnswer && currentWord.english.isNotEmpty);
      if (_isCorrect) {
        currentWord.correctStreak++;
        if (currentWord.correctStreak == 5) {
          if (currentWord.level == 'no idea') {
            currentWord.level = 'moderately known';
          } else if (currentWord.level == 'moderately known') {
            currentWord.level = 'well known';
          }
          currentWord.correctStreak = 0;
          currentWord.incorrectStreak = 0;
        }
      } else {
        currentWord.incorrectStreak++;
        if (currentWord.incorrectStreak == 3) {
          if (currentWord.level == 'well known') {
            currentWord.level = 'moderately known';
          } else if (currentWord.level == 'moderately known') {
            currentWord.level = 'no idea';
          }
          currentWord.correctStreak = 0;
          currentWord.incorrectStreak = 0;
        }
      }
    });
  }

  void _nextWord() {
    setState(() {
      if (_currentIndex < widget.words.length - 1) {
        _currentIndex++;
      } else {}
      _controller.clear();
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Word currentWord = widget.words[_currentIndex];
    String question = currentWord.english.isNotEmpty
        ? currentWord.english
        : currentWord.korean;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Translate this word: $question',
              style: const TextStyle(fontSize: 24)),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Your answer"),
          ),
          ElevatedButton(
            onPressed: _checkAnswer,
            child: const Text('Check'),
          ),
          if (_isCorrect)
            const Text('Correct!',
                style: TextStyle(color: Colors.green, fontSize: 20)),
          if (!_isCorrect && _controller.text.isNotEmpty)
            const Text('Wrong!',
                style: TextStyle(color: Colors.red, fontSize: 20)),
          ElevatedButton(
            onPressed: _nextWord,
            child: const Text('Next Word'),
          ),
          FloatingActionButton(
            onPressed: () {
              _saveWords();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  void _saveWords() async {
    for (var word in widget.words) {
      await DatabaseHelper.instance.insertWord(word);
    }
    Navigator.of(context);
  }
}
