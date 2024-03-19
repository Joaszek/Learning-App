import 'package:flutter/material.dart';
import 'package:learningapp/database_helper.dart';
import '../model/word.dart';
import 'quiz_page.dart';

class WordsListPage extends StatelessWidget {
  final List<Word> words;
  final String level;
  DatabaseHelper dbHelper = DatabaseHelper();

  WordsListPage({super.key, required this.words, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words List', style: TextStyle(fontSize: 32)),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${word.english} - ${word.korean}',
                  style: const TextStyle(fontSize: 24)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizPage(
                      words: words,
                      dbHelper: dbHelper,
                    )),
          );
        },
      ),
    );
  }
}
