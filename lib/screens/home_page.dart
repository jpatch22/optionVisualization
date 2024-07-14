import 'package:flutter/material.dart';
import 'package:option_visualizer/screens/binomial_assets.dart';
import 'op_at_ex_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Centers the column vertically in the middle of the screen
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OpAtExpPage()),
                );
              },
              child: Text('Go to Option Valuation Visualizer'),
            ),
            SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BinomialPage()),
                );
              },
              child: Text("Binomial Modelling Page"),
            ),
          ],
        ),
      ),
    );
  }
}
