import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;

  ChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container();
    }

    // Calculate the minimum and maximum Y values
    double minY = data.map((d) => d.y).reduce((a, b) => a < b ? a : b);
    double maxY = data.map((d) => d.y).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(),
        primaryYAxis: NumericAxis(
          minimum: minY,
          maximum: maxY,
        ),
        series: <ChartSeries>[
          LineSeries<ChartData, double>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ],
      ),
    );
  }
}
