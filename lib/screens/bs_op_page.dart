import 'package:flutter/material.dart';
import 'package:option_visualizer/models/row_data_extend.dart';
import 'package:option_visualizer/requests/bs_op_val_request.dart';
import 'package:option_visualizer/utils/util.dart';
import 'package:option_visualizer/widgets/row_item_extended.dart';
import '../models/row_data.dart';
import '../widgets/chart_widget.dart';
import '../process/row_data_processor.dart';
import '../models/chart_data.dart';
import '../widgets/time_slider.dart';  // Import the TimeSliderWidget

class BsOpPage extends StatefulWidget {
  @override
  _BsOpPageState createState() => _BsOpPageState();
}

class _BsOpPageState extends State<BsOpPage> {
  List<RowDataExtended> rows = [RowDataExtended()];
  List<ChartData> _chartData = [];
  List<List<double>> currentData = [];
  List<double> stockData = [];
  List<double> time = [];
  int timeIndex = 0;
  final RowDataProcessor _rowDataProcessor = RowDataProcessor();

  RangeValues _selectedRange = RangeValues(10, 15);
  final ValueNotifier<double> _maxVal = ValueNotifier(100.0);
  final ValueNotifier<double> _minVal = ValueNotifier(0.0);
  double maxRange = 100.0;
  final TextEditingController _stockValueController = TextEditingController();
  final TextEditingController _riskController = TextEditingController();
  final TextEditingController _volController = TextEditingController();
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
        title: Text('Valuing Options over time with Black Scholes'),
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
                          RowItemExtended(
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
            Text("Other Parameters:"),
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
                SizedBox(width: 10),
                Row(
                  children: [
                    Text('Risk-Free Rate: '),
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _riskController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text('Expected Volatility: '),
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _volController,
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
            // Include the TimeSliderWidget here
            if (time.isNotEmpty)
              TimeSliderWidget(
                time: time,
                onTimeIndexChanged: (int index) {
                  setState(() {
                    timeIndex = index;
                    _drawPlot();
                  });
                },
              ),
            SizedBox(height: 10),
            Container(
              height: 400,
              child: ChartWidget(
                data: _chartData,
                xAxisLabel: "Stock Price At Expriy",
                yAxisLabel: "Return",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addRow() {
    setState(() {
      rows.add(RowDataExtended());
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
      rows.insert(index + 1, RowDataExtended());
    });
  }

  void removeRowAt(int index) {
    if (rows.length > 1) {
      setState(() {
        rows.removeAt(index);
      });
    }
  }

  Future<void> _generatePlot() async {
    double stockValue = double.tryParse(_stockValueController.text) ?? 0.0;
    double rate = double.tryParse(_riskController.text) ?? 0.0;
    double vol = double.tryParse(_volController.text) ?? 0.0;
    _selectedRange = RangeValues(stockValue * 0.75, stockValue * 1.25);
    _selectedRangeNotifier.value = _selectedRange;
    _minVal.value = 0.0;
    _maxVal.value = 10 * stockValue;

    Future<String?> body = BsOpValRequest.getOptionValues(
      rows,
      rate,
      vol,
      stockValue
    );
    String? res = await body;
    if (res == null) {
      return;
    }
    time = Utils.parse1DArrayFromJson(res, "time");
    stockData = Utils.parse1DArrayFromJson(res, "stock");
    currentData = Utils.parse2DArrayFromJson(res, "optionPrices");

    _drawPlot();
  }

  void _drawPlot() {
    setState(() {
      if (currentData.isNotEmpty) {
        List<double> otherRet = currentData.map((row) => row[timeIndex]).toList();
        _chartData = Utils.convertArrayToChart([stockData, otherRet]);
      }
    });
  }
}
