import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final String xAxisLabel;
  final String yAxisLabel;

  ChartWidget({
    required this.data,
    required this.xAxisLabel,
    required this.yAxisLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container();
    }

    // Calculate the minimum and maximum Y values
    double minY = data.map((d) => d.y).reduce((a, b) => a < b ? a : b);
    double maxY = data.map((d) => d.y).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 500,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          title: AxisTitle(
            text: xAxisLabel,
            textStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: yAxisLabel,
            textStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
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
