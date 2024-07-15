import 'package:flutter/material.dart';
import '../models/tree_node.dart';

class TreePainter extends CustomPainter {
  final TreeNode root;
  final double nodeWidth;
  final double nodeHeight;
  final double horizontalSpacing;
  final double verticalSpacing;

  TreePainter(this.root, {
    this.nodeWidth = 80.0,  // Adjusted size
    this.nodeHeight = 40.0, // Adjusted size
    this.horizontalSpacing = 60.0,
    this.verticalSpacing = 40.0
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    void drawNode(TreeNode node, Offset position) {
      // Draw the bubble (rectangle with rounded corners) around the text
      final Rect rect = Rect.fromCenter(center: position, width: nodeWidth, height: nodeHeight);
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
      canvas.drawRRect(rrect, Paint()..color = Colors.blueAccent);

      // Draw the text
      textPainter.text = TextSpan(
        text: node.value,
        style: TextStyle(color: Colors.white, fontSize: 14), // Adjusted font size
      );
      textPainter.layout(minWidth: 0, maxWidth: nodeWidth - 20);
      final Offset textOffset = Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);

      final double childX = position.dx + horizontalSpacing + nodeWidth / 2;
      final double offsetY = verticalSpacing;

      for (int i = 0; i < node.children.length; i++) {
        final double childY = position.dy + (i - node.children.length / 2 + 0.5) * offsetY;
        final Offset childPosition = Offset(childX, childY);
        final Offset lineStart = Offset(position.dx + nodeWidth / 2, position.dy);
        final Offset lineEnd = Offset(childPosition.dx - nodeWidth / 2, childPosition.dy);
        canvas.drawLine(lineStart, lineEnd, paint);
        drawNode(node.children[i], childPosition);
      }
    }

    drawNode(root, Offset(nodeWidth / 2 + 20, size.height / 2));
  }

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return oldDelegate.root != root;
  }
}
