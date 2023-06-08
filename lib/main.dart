import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_word_chat/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: "KBO",
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
            foregroundColor: Colors.black,
          )),
      home: const Home(),
    );
  }
}
