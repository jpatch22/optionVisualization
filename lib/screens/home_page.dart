import 'package:flutter/material.dart';
import 'package:option_visualizer/screens/asset_sim.dart';
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
              .min,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BinomialPage()),
                );
              },
              child: Text("Binomial Modelling Page"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssetSimPage())
              );
            }, 
            child: Text("Asset Price Simulation"))
          ],
        ),
      ),
    );
  }
}
