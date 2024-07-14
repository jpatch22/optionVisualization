import 'package:flutter/material.dart';

class BinomialPage extends StatefulWidget {
  @override
  _BinomialPageState createState() => _BinomialPageState();
}

class _BinomialPageState extends State<BinomialPage> {
  bool isBase = true;

  final TextEditingController uController = TextEditingController();
  final TextEditingController vController = TextEditingController();
  final TextEditingController volController = TextEditingController();
  final TextEditingController dtController = TextEditingController();
  final TextEditingController numStepsController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binomial Assets & Options'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isBase = !isBase;
                });
              },
              child: Text(isBase ? 'Switch to Drift' : 'Switch to Base'),
            ),
            SizedBox(height: 20),
            // Display different text fields based on the state
            isBase ? buildBaseFields() : buildDriftFields(),
          ],
        ),
      ),
    );
  }

  Widget buildBaseFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('u'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: uController,
                decoration: InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('v'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: vController,
                decoration: InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Initial Stock Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Num Steps'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: numStepsController,
                decoration: const InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDriftFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('vol'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: volController,
                decoration: InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('dt'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: dtController,
                decoration: InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Initial Stock Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Num Steps'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: numStepsController,
                decoration: const InputDecoration(
                  isDense: true, // Reduces the height of the text field
                  contentPadding: EdgeInsets.all(8), // Adjust padding to make it smaller
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
