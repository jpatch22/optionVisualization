import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:option_visualizer/models/chart_data3D.dart';

class ChartWidget3D extends StatelessWidget {
  final List<ChartData3D> data;
  final String xAxisLabel;
  final String yAxisLabel;
  final String zAxisLabel;

  ChartWidget3D({
    required this.data,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.zAxisLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container();
    }

    final List<Map<String, dynamic>> seriesData = data
        .map((d) => {'value': [d.x, d.y, d.z]})
        .toList();

    final String option = '''
    {
      "tooltip": {},
      "visualMap": {
        "max": ${data.map((d) => d.z).reduce((a, b) => a > b ? a : b)},
        "inRange": {
          "color": [
            "#1710c0",
            "#0b9df0",
            "#00fea8",
            "#00ff0d",
            "#f5f811",
            "#f09a09",
            "#fe0300"
          ]
        }
      },
      "xAxis3D": {
        "type": "value",
        "name": "$xAxisLabel"
      },
      "yAxis3D": {
        "type": "value",
        "name": "$yAxisLabel"
      },
      "zAxis3D": {
        "type": "value",
        "name": "$zAxisLabel"
      },
      "grid3D": {
        "viewControl": {
          "projection": "orthographic"
        }
      },
      "series": [
        {
          "type": "scatter3D",
          "data": $seriesData
        }
      ]
    }
    ''';

    return Container(
      height: 500,
      child: Echarts(
        option: option,
      ),
    );
  }
}
