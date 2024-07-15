import 'package:flutter/material.dart';
import '../models/tree_node.dart';
import '../painter/tree_painter.dart';

class TreeView extends StatefulWidget {
  final TreeNode root;

  TreeView({required this.root});

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  TransformationController _transformationController = TransformationController();
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _scale *= 1.1;
      _transformationController.value = Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale /= 1.1;
      _transformationController.value = Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onScaleStart: (details) {
            _transformationController.value = Matrix4.identity();
          },
          onScaleUpdate: (details) {
            setState(() {
              _scale = details.scale;
              _offset = details.focalPoint;
            });
          },
          onScaleEnd: (details) {
            setState(() {
              _transformationController.value = Matrix4.identity()
                ..translate(_offset.dx, _offset.dy)
                ..scale(_scale);
            });
          },
          child: InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.1,
            maxScale: 4.0,
            child: CustomPaint(
              size: Size.infinite,
              painter: TreePainter(widget.root),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                child: Icon(Icons.zoom_in),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _zoomOut,
                child: Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
