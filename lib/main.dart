import 'package:flutter/material.dart';
import 'package:the_basics/home.dart';
import 'package:the_basics/load.dart';
import 'package:the_basics/pages/indexing.dart';
import 'package:the_basics/pages/results.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lab3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Search System'),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const Load(),
        '/home': (BuildContext context) => const Home(title: 'Search System'),
        '/results': (BuildContext context) => const Results(),
        '/indexing': (BuildContext context) => const Indexing(),
      },
    );
  }
}
