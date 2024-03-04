import 'package:flutter/material.dart';
import 'package:learningapp/screens/MainPage.dart';
import 'package:learningapp/word_provider.dart';
import 'package:provider/provider.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => WordProvider(),
        child: const KoreanLearningApp(),
      ),
    );
// Future main() async {
// // Initialize FFI
//   sqfliteFfiInit();

//   databaseFactory = databaseFactoryFfi;
//   runApp(KoreanLearningApp());
// }

class KoreanLearningApp extends StatelessWidget {
  const KoreanLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
