import 'package:flutter/material.dart';
import 'package:learningapp/screens/main_page.dart';
import 'package:learningapp/word_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => WordProvider(),
        child: const KoreanLearningApp(),
      ),
    );

class KoreanLearningApp extends StatelessWidget {
  const KoreanLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
