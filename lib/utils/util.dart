import 'package:option_visualizer/models/tree_node.dart';

class Utils {
  static TreeNode? convertArrayToTree(List<List<double>> arr) {
    int treeSize = arr.length;
    if (treeSize == 0) {
      return null;
    }
    TreeNode root = TreeNode(arr[0][0].toString());


    return root;
  }
}