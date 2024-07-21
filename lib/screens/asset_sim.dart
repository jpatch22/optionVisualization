import 'dart:math';
import 'package:flutter/material.dart';
import 'package:option_visualizer/requests/asset_sim_request.dart';
import 'package:option_visualizer/utils/util.dart';
import '../widgets/range_selector.dart';
import '../widgets/chart_widget.dart';
import '../models/chart_data.dart';
import '../widgets/range_selector.dart';

class AssetSimPage extends StatefulWidget {
  @override
  _AssetSimPageState createState() => _AssetSimPageState();
}

class _AssetSimPageState extends State<AssetSimPage> {
  RangeValues _selectedRange = RangeValues(10, 15);
  final ValueNotifier<double> _maxVal = ValueNotifier(100.0);
  final ValueNotifier<double> _minVal = ValueNotifier(0.0);
  final ValueNotifier<RangeValues> _selectedRangeNotifier = ValueNotifier(RangeValues(10, 15));
  List<ChartData> _chartData = [ChartData(1, 5), ChartData(2, 6)];
  final TextEditingController _stockValueController = TextEditingController();
  final TextEditingController _driftController = TextEditingController();
  final TextEditingController _volController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _nController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Price Simulator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('Stock Price: '),
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
                    SizedBox(width: 10),
                    Text('Drift Rate: '),
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _driftController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        )),
                    SizedBox(width: 10),
                    Text('Volatility: '),
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _volController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        )),
                    SizedBox(width: 10),
                    Text('Time Period: '),
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        )),
                    SizedBox(width: 10),
                    Text('Increments: '),
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _nController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ))
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generatePlot,
              child: Text('Generate Plot'),
            ),
            SizedBox(height: 10),
            // RangeSelector(
              // minNotifier: _minVal,
              // maxNotifier: _maxVal,
              // rangeNotifier: _selectedRangeNotifier,
              // onRangeChanged: (values) {
                // _selectedRange = values;
                // _drawPlot(null);
              // },
            // ),
            SizedBox(height: 10),
            Container(
              height: 400,
              child: ChartWidget(data: _chartData, xAxisLabel: "Time (Years)", yAxisLabel: "Stock Price",),
            ),
          ],
        ),
      ),
    );
  }

  void _generatePlot() async {
    Future<List<List<double>>?> assetValsFuture = AssetSimRequest.sendAssSimReq(
      double.tryParse(_stockValueController.text) ?? 0,
      double.tryParse(_timeController.text) ?? 0,
      double.tryParse(_volController.text) ?? 0,
      double.tryParse(_driftController.text) ?? 0,
      int.tryParse(_nController.text) ?? 0,
    );
    List<List<double>>? assetPrices = await assetValsFuture;
    if (assetPrices == null) {
      return;
    }

    _drawPlot(assetPrices);
  }

  void _drawPlot(List<List<double>>? lst) {
    if (lst == null) {
      return;
    }
    List<ChartData> res = Utils.convertArrayToChart(lst);
    setState(() {
      _chartData = res;
    });
  }
}