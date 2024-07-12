import 'dart:math';
import '../models/chart_data.dart';

class DataGenerator {
  List<ChartData> generateRandomData(int count) {
    final random = Random();
    return List<ChartData>.generate(count, (i) {
      double x = i.toDouble();
      double y = sin(x * pi / 50) + random.nextDouble() * 0.5;
      return ChartData(x, y);
    }).toList();
  }
}