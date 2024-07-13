import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/op_at_ex_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/my_home': (context) => OpAtExpPage(),
      },
    );
  }
}
