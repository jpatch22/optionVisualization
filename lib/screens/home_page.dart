import 'package:flutter/material.dart';
import 'op_at_ex_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OpAtExpPage()),
            );
          },
          child: Text('Go to Option Valuation Visualizer'),
        ),
      ),
    );
  }
}
