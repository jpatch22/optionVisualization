import 'package:flutter/material.dart';
import '../models/tree_node.dart';
import '../painter/tree_painter.dart';

class TreeView extends StatelessWidget {
  final TreeNode root;

  TreeView({required this.root});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TreePainter(root),
      child: Container(), // Use a Container to define the size of the CustomPaint
    );
  }
}
