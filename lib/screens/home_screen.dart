import 'package:flutter/material.dart';
import '../models/row_data.dart';
import '../widgets/row_item.dart';
import '../widgets/chart_widget.dart';
import '../process/data_generator.dart';
import '../process/row_data_processor.dart';
import '../models/chart_data.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RowData> rows = [RowData()];
  List<ChartData> _chartData = [];
  final DataGenerator _dataGenerator = DataGenerator();
  final RowDataProcessor _rowDataProcessor = RowDataProcessor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Option Valuation Visualizer'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Long/Short'),
              Text('Put/Call'),
              Text('Contract Price'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: addRow,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: removeRow,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return RowItem(
                  key: UniqueKey(),
                  rowData: rows[index],
                  onAdd: () => addRowAt(index),
                  onRemove: () => removeRowAt(index),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateRandomData,
            child: Text('Generate Plot'),
          ),
          SizedBox(height: 20),
          ChartWidget(data: _chartData),
        ],
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
    setState(() {
      // _chartData = _dataGenerator.generateRandomData(100);
      _chartData = _rowDataProcessor.calcMultOptionValAtExpiry(rows, 10, 15);
    });
  }
}
