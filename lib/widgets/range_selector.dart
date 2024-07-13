import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  final double min;
  final double max;
  final ValueNotifier<RangeValues> rangeNotifier;
  final ValueChanged<RangeValues> onRangeChanged;

  RangeSelector({
    Key? key,
    required this.min,
    required this.max,
    required this.rangeNotifier,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  _RangeSelectorState createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  @override
  void initState() {
    super.initState();
    widget.rangeNotifier.addListener(_updateRange);
  }

  @override
  void dispose() {
    widget.rangeNotifier.removeListener(_updateRange);
    super.dispose();
  }

  void _updateRange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rangeValues = widget.rangeNotifier.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Select Range:',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              'Start: ${rangeValues.start.round()}',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: RangeSlider(
                values: rangeValues,
                min: widget.min,
                max: widget.max,
                divisions: 100,
                labels: RangeLabels(
                  rangeValues.start.round().toString(),
                  rangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  widget.rangeNotifier.value = values;
                  widget.onRangeChanged(values); // Notify parent of changes
                },
              ),
            ),
            Text(
              'End: ${rangeValues.end.round()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Selected range: ${rangeValues.start.round()} - ${rangeValues.end.round()}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
