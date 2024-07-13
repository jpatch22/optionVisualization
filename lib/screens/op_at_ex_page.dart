import 'package:flutter/material.dart';
import '../models/row_data.dart';
import '../widgets/row_item.dart';
import '../widgets/chart_widget.dart';
import '../process/row_data_processor.dart';
import '../models/chart_data.dart';
import '../widgets/range_selector.dart';

class OpAtExpPage extends StatefulWidget {
  @override
  _OpAtExpPageState createState() => _OpAtExpPageState();
}

class _OpAtExpPageState extends State<OpAtExpPage> {
  List<RowData> rows = [RowData()];
  List<ChartData> _chartData = [];
  final RowDataProcessor _rowDataProcessor = RowDataProcessor();

  RangeValues _selectedRange = RangeValues(10, 15);
  final ValueNotifier<double> _maxVal = ValueNotifier(100.0);
  final ValueNotifier<double> _minVal = ValueNotifier(0.0);
  double maxRange = 100.0;
  final TextEditingController _stockValueController = TextEditingController();
  final ValueNotifier<RangeValues> _selectedRangeNotifier = ValueNotifier(RangeValues(10, 15));

  @override
  void initState() {
    super.initState();
    _drawPlot();
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
                  onPressed: _generatePlot,
                  child: Text('Generate Plot'),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text('Stock Value: '),
                    Container(
                      width: 100,
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
              minNotifier: _minVal,
              maxNotifier: _maxVal,
              rangeNotifier: _selectedRangeNotifier,
              onRangeChanged: (values) {
                _selectedRange = values;
                _drawPlot();
              },
            ),
            SizedBox(height: 10),
            Container(
              height: 400,
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

  void _generatePlot() {
    double stockValue = double.tryParse(_stockValueController.text) ?? 0.0;
    _selectedRange = RangeValues(stockValue * 0.75, stockValue * 1.25);
    _selectedRangeNotifier.value = _selectedRange;
    _minVal.value = 0.0;
    _maxVal.value = 10 * stockValue;

    _drawPlot();
  }

  void _drawPlot() {
    setState(() {
      _chartData = _rowDataProcessor.calcMultOptionValAtExpiry(
        rows,
        _selectedRange.start,
        _selectedRange.end,
      );
    });
  }
}
