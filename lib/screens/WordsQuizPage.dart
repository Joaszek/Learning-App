import 'package:flutter/material.dart';
import 'package:learningapp/model/Word.dart';

class WordsQuizPage extends StatelessWidget {
  final List<Word> words = [
    Word(english: 'Hello', korean: '안녕하세요', level: 'no idea'),
  ];

  WordsQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Korean'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Word List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return ListTile(
                  title: Text('${word.english} - ${word.korean}'),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey[50],
              child: const Center(
                child: Text(
                  'Quiz Section',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
