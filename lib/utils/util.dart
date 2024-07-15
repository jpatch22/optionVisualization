import 'package:option_visualizer/models/tree_node.dart';
import '../models/tuple.dart';

class Utils {
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
        TreeNode newNode = TreeNode(arr[i][j].toString());
        treeMap[Tuple(i, j)] = newNode;
        if (j - 1 >= 0) {
          treeMap[Tuple(i - 1, j - 1)]?.children.add(newNode);
        }
        if (j < i) {
          treeMap[Tuple(i - 1, j)]?.children.add(newNode);
        }
      }
    }
    print("$root");

    return root;
  }
}
