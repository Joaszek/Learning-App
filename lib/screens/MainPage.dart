import 'package:flutter/material.dart';
import '../model/Word.dart';
import 'WordsListPage.dart';
import '../DatabaseHelper.dart'; // Upewnij się, że ta klasa jest poprawnie zaimplementowana

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DatabaseHelper _dbHelper =
      DatabaseHelper.instance; // Instancja DatabaseHelper
  List<Word> words = [];

  void _addWord(String english, String korean, String level) async {
    final newWord = Word(english: english, korean: korean, level: level);
    await _dbHelper.insertWord(newWord);
  }

  Future<void> _refreshWordsList(String level) async {
    final _new_words = await _dbHelper.getWordsByLevel(level);
    setState(() {
      words = _new_words;
    });
  }

  void _showAddWordDialog() {
    final TextEditingController englishController = TextEditingController();
    final TextEditingController koreanController = TextEditingController();
    String selectedLevel = 'no idea'; // Domyślny poziom

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Word'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: englishController,
                  decoration: const InputDecoration(hintText: "English word"),
                ),
                TextField(
                  controller: koreanController,
                  decoration: const InputDecoration(hintText: "Korean word"),
                ),
                DropdownButton<String>(
                  value: selectedLevel,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLevel = newValue!;
                    });
                  },
                  items: <String>['no idea', 'moderately known', 'well known']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await _dbHelper.insertWord(Word(
                    english: englishController.text,
                    korean: koreanController.text,
                    level: selectedLevel));
                await _refreshWordsList("no idea");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Ta funkcja odpowiada za nawigację do strony, która wyświetla słowa na podstawie poziomu
  void _showWordsByLevel(String level) async {
    // Pobieranie słów z bazy danych na podstawie poziomu
    final words = await _dbHelper.getWordsByLevel(level);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WordsListPage(words: words, level: level)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Learning App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _refreshWordsList("no idea");
                _showWordsByLevel('no idea');
              },
              child: const Text(
                'No Idea',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _refreshWordsList('moderately known');
                _showWordsByLevel('moderately known');
              },
              child: const Text(
                'Moderately Known',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _refreshWordsList('well known');
                _showWordsByLevel('well known');
              },
              child: const Text(
                'Well Known',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: _showAddWordDialog,
              child: const Text(
                'Add New Word',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
