import 'package:flutter/material.dart';
import '../models/row_data.dart';
import '../widgets/row_item.dart';
import '../widgets/chart_widget.dart';
import '../process/data_generator.dart';
import '../process/row_data_processor.dart';
import '../models/chart_data.dart';
import '../widgets/range_selector.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RowData> rows = [RowData()];
  List<ChartData> _chartData = [];
  final DataGenerator _dataGenerator = DataGenerator();
  final RowDataProcessor _rowDataProcessor = RowDataProcessor();

  RangeValues _selectedRange = RangeValues(10, 15);
  TextEditingController _stockValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRandomData(); // Initial plot generation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Option Valuation Visualizer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FixedColumnWidth(50),
                      4: FixedColumnWidth(50),
                    },
                    children: [
                      TableRow(
                        children: [
                          RowItem(
                            key: UniqueKey(),
                            rowData: rows[index],
                            onAdd: () => addRowAt(index),
                            onRemove: () => removeRowAt(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _generateRandomData,
                  child: Text('Generate Plot'),
                ),
                SizedBox(width: 10), // Adjust the width as needed
                Row(
                  children: [
                    Text('Stock Value: '),
                    Container(
                      width: 100, // Adjust the width as needed
                      child: TextField(
                        controller: _stockValueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            RangeSelector(
              min: 0,
              max: 20,
              initialRange: _selectedRange,
              onRangeChanged: (values) {
                setState(() {
                  _selectedRange = values;
                  _generateRandomData(); // Redraw plot on range change
                });
              },
            ),
            SizedBox(height: 10),
            Container(
              height: 400, // Adjust this value to make the plot larger vertically
              child: ChartWidget(data: _chartData),
            ),
          ],
        ),
      ),
    );
  }

  void addRow() {
    setState(() {
      rows.add(RowData());
    });
  }

  void removeRow() {
    if (rows.length > 1) {
      setState(() {
        rows.removeLast();
      });
    }
  }

  void addRowAt(int index) {
    setState(() {
      rows.insert(index + 1, RowData());
    });
  }

  void removeRowAt(int index) {
    if (rows.length > 1) {
      setState(() {
        rows.removeAt(index);
      });
    }
  }

  void _generateRandomData() {
    double stockValue = double.tryParse(_stockValueController.text) ?? 0.0;
    setState(() {
      _chartData = _rowDataProcessor.calcMultOptionValAtExpiry(
        rows,
        _selectedRange.start,
        _selectedRange.end,
      );
    });
  }
}
