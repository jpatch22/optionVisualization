import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/row_data.dart';
import '../widgets/row_item.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RowData> rows = [RowData()];
  List<_ChartData> _chartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dynamic Rows'),
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
          _buildChart(),
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
    final random = Random();
    final data = List.generate(100, (i) {
      double x = i.toDouble();
      double y = sin(x * pi / 50) + random.nextDouble() * 0.5;
      return _ChartData(x, y);
    });

    setState(() {
      _chartData = data;
    });
  }

  Widget _buildChart() {
    return _chartData.isEmpty
        ? Container()
        : SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(),
              primaryYAxis: NumericAxis(),
              series: <ChartSeries>[
                LineSeries<_ChartData, double>(
                  dataSource: _chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                )
              ],
            ),
          );
  }
}

class _ChartData {
  final double x;
  final double y;

  _ChartData(this.x, this.y);
}
