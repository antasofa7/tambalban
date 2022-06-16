import 'package:flutter/material.dart';
import 'package:tambal_ban/pages/add_place.dart';
import 'package:tambal_ban/pages/home.dart';
import 'package:tambal_ban/pages/search_page.dart';
import 'package:tambal_ban/pages/started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const StartedPage(),
        '/home': (context) => const HomePage(),
        '/addPlace': (context) => const AddPlace(),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}
