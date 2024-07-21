import 'package:option_visualizer/models/chart_data.dart';
import 'package:option_visualizer/models/tree_node.dart';
import '../models/tuple.dart';
import 'dart:convert';

class Utils {
  static List<ChartData> convertArrayToChart(List<List<double>> items) {
    List<ChartData> res = [];
    for (int i = 0; i < items[0].length; i++) {
      res.add(ChartData(items[0][i], items[1][i]));
    }
    return res;
  }

  static TreeNode? convertArrayToTree(List<List<double>> arr) {
    int treeSize = arr.length;
    if (treeSize == 0) {
      return null;
    }
    TreeNode root = TreeNode(arr[0][0].toString());
    Map<Tuple, TreeNode> treeMap = {};
    treeMap[Tuple(0, 0)] = root;
    for (int i = 1; i < treeSize; i++) {
      for (int j = 0; j <= i; j++) {
        TreeNode newNode = TreeNode(arr[i][j].toStringAsFixed(2));
        treeMap[Tuple(i, j)] = newNode;
        if (j - 1 >= 0) {
          treeMap[Tuple(i - 1, j - 1)]?.children.add(newNode);
        }
        if (j < i) {
          treeMap[Tuple(i - 1, j)]?.children.add(newNode);
        }
      }
    }

    return root;
  }

  static List<List<double>> parseAssetPrices(String jsonString, String key) {
    final jsonResponse = json.decode(jsonString);
    final assetPricesJson = jsonResponse[key] as List<dynamic>;

    List<List<double>> assetPrices = assetPricesJson.map((row) {
      return (row as List<dynamic>).map((value) => value as double).toList();
    }).toList();

    return assetPrices;
  }
}
