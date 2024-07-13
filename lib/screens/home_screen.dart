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
          Expanded(
            child: ListView.builder(
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
      _chartData = _rowDataProcessor.calcMultOptionValAtExpiry(rows, 10, 15);
    });
  }
}
