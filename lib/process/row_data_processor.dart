import 'dart:math';
import '../models/row_data.dart';
import '../models/chart_data.dart';

class RowDataProcessor {
  List<ChartData> processRowData(List<RowData> rows) {
    List<ChartData> chartData = [];
    final random = Random();

    for (int i = 0; i < rows.length; i++) {
      double x = i.toDouble();
      double y = (rows[i].contractPrice.isNotEmpty ? double.parse(rows[i].contractPrice) : 0) + random.nextDouble() * 0.5;
      chartData.add(ChartData(x, y));
    }

    return chartData;
  }

  List<double> createRange(double a, double b, double c) {
    if (c == 0) {
      throw ArgumentError("Step must be non-zero.");
    }
    if (a == b) {
      return [a];
    }
  
    List<double> rangeList = [];
    if (a < b && c > 0) {
      for (double i = a; i <= b; i += c) {
        rangeList.add(i);
      }
    } else if (a > b && c < 0) {
      for (double i = a; i >= b; i += c) {
        rangeList.add(i);
      }
    } else {
      throw ArgumentError("Step value must correctly progress towards the end value.");
    }
  
    return rangeList;
  }

  List<ChartData> calcMultOptionValAtExpiry(List<RowData> rows, double stockStart, double stockEnd) {
    List<List<ChartData>> optionValues = [];
    for (RowData row in rows) {
      optionValues.add(calcOptionValueAtExpiry(row, stockStart, stockEnd));
    }
    if (optionValues.isEmpty) {
      return [];
    }
    List<ChartData> res = [];

    for (int i = 0; i < optionValues[0].length; i++) {
      double ysum = 0.0;
      for (int j = 0; j < optionValues.length; j++) {
        ysum += optionValues[j][i].y;
      }
      res.add(ChartData(optionValues[0][i].x, ysum));
    }
    return res;
  }

  List<ChartData> calcOptionValueAtExpiry(RowData row, double stockStart, double stockEnd) {
    double step = (stockEnd - stockStart) / 1000.0;
    List<double> stockPriceRange = createRange(stockStart, stockEnd, step);

    List<ChartData> chartData = [];
    List<double> yList = [];
    if (row.contractPrice.isEmpty) {
      return [];
    }
    double contractPrice = row.contractPrice.isNotEmpty ? double.parse(row.contractPrice) : 0.0;


    if (row.longShort == "Long" && row.putCall == "Call") {
      yList = [for (double sp in stockPriceRange) max(0.0, sp - contractPrice)];
    } else if (row.longShort == "Long" && row.putCall == "Put") {
      yList = [for (double sp in stockPriceRange) max(0.0, contractPrice - sp)];
    } else if (row.putCall == "Call") {
      yList = [for (double sp in stockPriceRange) min(0.0, contractPrice - sp)];
    } else {
      yList = [for (double sp in stockPriceRange) min(0.0, sp - contractPrice)];
    }
    for (int i = 0; i < stockPriceRange.length; i++) {
      chartData.add(ChartData(stockPriceRange[i], yList[i]));
    }
    return chartData;
  }
}
